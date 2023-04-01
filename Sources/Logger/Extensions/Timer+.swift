//
// Timer+.swift
// Copyright (c) 2022 Logger
//
// Created by Hamed Hosseini on 12/14/22

import Foundation

public protocol TimerProtocol {
    @discardableResult
    func scheduledTimer(interval: TimeInterval, repeats: Bool, block: @escaping @Sendable (Timer) -> Void) -> Timer
    func invalidateTimer()
    var isValid: Bool { get }
}

extension Timer: TimerProtocol {
    @discardableResult
    public func scheduledTimer(interval: TimeInterval, repeats: Bool, block: @escaping @Sendable (Timer) -> Void) -> Timer {
        Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: block)
    }

    public func invalidateTimer() {
        invalidate()
    }
}
