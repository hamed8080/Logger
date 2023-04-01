//
// LoggerConfig.swift
// Copyright (c) 2022 Logger
//
// Created by Hamed Hosseini on 12/14/22

import Foundation

public struct LoggerConfig: Codable {
    var prefix: String
    var logServerURL: String?
    var logServerMethod: String = "POST"
    var logServerRequestheaders = [String: String]()
    var persistLogsOnServer: Bool = false
    var sendLogInterval: TimeInterval = 60

    /// - isDebuggingLogEnabled: If debugging is set true in the console you'll see logs for messages that send and receive and also what's happening when the socket state changes.
    var isDebuggingLogEnabled: Bool = false

    /// - isDebuggingLogEnabled: If debugging is set true in the console you'll see logs for messages that send and receive and also what's happening when the socket state changes.
    public init(prefix: String,
                logServerURL: String? = nil,
                logServerMethod: String = "POST",
                persistLogsOnServer: Bool = false,
                isDebuggingLogEnabled: Bool = false,
                sendLogInterval: TimeInterval = 60,
                logServerRequestheaders: [String: String] = [:])
    {
        self.prefix = prefix
        self.logServerURL = logServerURL
        self.logServerMethod = logServerMethod
        self.persistLogsOnServer = persistLogsOnServer
        self.isDebuggingLogEnabled = isDebuggingLogEnabled
        self.sendLogInterval = sendLogInterval
        self.logServerRequestheaders = logServerRequestheaders
    }
}
