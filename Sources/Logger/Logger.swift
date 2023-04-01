//
// Logger.swift
// Copyright (c) 2022 Logger
//
// Created by Hamed Hosseini on 12/14/22

import CoreData
import Foundation

public final class Logger {
    public var delegate: LogDelegate?
    private var config: LoggerConfig
    private var timer: TimerProtocol
    private var urlSession: URLSessionProtocol
    private let persistentManager = PersistentManager()

    public init(config: LoggerConfig, delegate: LogDelegate? = nil, timer: TimerProtocol = Timer(), urlSession: URLSessionProtocol = URLSession.shared) {
        self.config = config
        self.delegate = delegate
        self.timer = timer
        self.urlSession = urlSession
        startSending()
    }

    public func logJSON(title: String? = nil, jsonString: String? = nil, persist: Bool, type: LogEmitter, userInfo: [String: String]? = nil) {
        log(message: "\(config.prefix)\(title ?? "")\(jsonString != nil ? "\n" : "")\(jsonString?.preetyJsonString() ?? "")", persist: persist, type: type, userInfo: userInfo)
    }

    public func log(title: String? = nil, message: String? = nil, persist: Bool, type: LogEmitter, userInfo: [String: String]? = nil) {
        log(message: "\(config.prefix)\(title ?? "")\(message != nil ? "\n" : "")\(message ?? "")", persist: persist, type: type, userInfo: userInfo)
    }

    public func logHTTPRequest(_ request: URLRequest, _ decodeType: String, persist: Bool, type: LogEmitter, userInfo: [String: String]? = nil) {
        var output = "\n"
        output += "Start Of Request====\n"
        output += " REST Request With Method:\(request.httpMethod ?? "") - url:\(request.url?.absoluteString ?? "")\n"
        output += " With Headers:\(request.allHTTPHeaderFields?.debugDescription ?? "[]")\n"
        output += " With HttpBody:\(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "nil")\n"
        output += " Expected DecodeType:\(decodeType)\n"
        output += "End Of Request====\n"
        output += "\n"
        log(title: "", message: output, persist: persist, type: type, userInfo: userInfo)
    }

    public func logHTTPResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, persist: Bool, type: LogEmitter, userInfo: [String: String]? = nil) {
        var output = "\n"
        output += "Start Of Response====\n"
        output += " REST Response For url:\(response?.url?.absoluteString ?? "")\n"
        output += " With Data Result in Body:\(String(data: data ?? Data(), encoding: .utf8) ?? "nil")\n"
        output += "End Of Response====\n"
        output += "\n"
        log(title: "", message: output, persist: persist, type: type, userInfo: userInfo)
        if let error = error {
            log(message: "\(error.localizedDescription) \n\(output)", persist: persist, level: .error, type: type, userInfo: userInfo)
        }
    }

    public func log(message: String, persist: Bool, level: LogLevel = .verbose, type: LogEmitter, userInfo: [String: String]? = nil) {
        let log = Log(
            message: message,
            level: level,
            type: type,
            userInfo: userInfo
        )
        delegate?.onLog(log: log)
        if persist, config.persistLogsOnServer {
            addLogToCache(log)
            if !timer.isValid {
                startSending()
            }
        }
    }

    private func startSending() {
        if config.persistLogsOnServer == false { return }
        timer.scheduledTimer(interval: 5, repeats: true) { [weak self] timer in
            if let bgTask = self?.persistentManager.newBgTask(), let self = self, timer.isValid {
                CDLog.firstLog(self, bgTask) { log in
                    if let log = log {
                        self.sendLog(log: log, context: bgTask)
                    } else {
                        timer.invalidateTimer()
                    }
                }
            }
        }
    }

    private func sendLog(log: CDLog, context: NSManagedObjectContext) {
        guard let urlString = config.logServerURL, let url = URL(string: urlString) else { return }
        var req = URLRequest(url: url)
        req.httpMethod = config.logServerMethod
        req.httpBody = try? JSONEncoder().encode(log.codable)
        req.allHTTPHeaderFields = config.logServerRequestheaders
        let task = urlSession.dataTask(req) { [weak self] _, response, error in
            if (response as? HTTPURLResponse)?.statusCode == 200 {
                self?.deleteLogFromCache(log: log, context: context)
            }

            if let error = error {
                print("error to send log \(error)")
            }
        }
        task.resume()
    }

    private func deleteLogFromCache(log: CDLog, context: NSManagedObjectContext) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            CDLog.delete(logger: self, context: context, logs: [log])
        }
    }

    private func addLogToCache(_ log: Log) {
        guard let context = persistentManager.context else { return }
        CDLog.insert(self, context, [log])
    }
}
