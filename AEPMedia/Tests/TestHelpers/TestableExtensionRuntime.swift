/*
 Copyright 2020 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

import Foundation

@testable import AEPCore

class TestableExtensionRuntime: ExtensionRuntime {
    var listeners: [String: EventListener] = [:]
    var dispatchedEvents: [Event] = []
    var createdSharedStates: [[String: Any]?] = []
    public var createdXdmSharedStates: [[String: Any]?] = []
    var otherSharedStates: [String: SharedStateResult] = [:]
    var otherXDMSharedStates: [String: SharedStateResult] = [:]

    let dispatchQueue = DispatchQueue(label: "")

    func getListener(type: String, source: String) -> EventListener? {
        return listeners["\(type)-\(source)"]
    }

    func simulateComingEvent(event: Event) {
        dispatchQueue.async {
            self.listeners["\(event.type)-\(event.source)"]?(event)
            self.listeners["\(EventType.wildcard)-\(EventSource.wildcard)"]?(event)
        }
    }

    func unregisterExtension() {
        // no-op
    }

    func registerListener(type: String, source: String, listener: @escaping EventListener) {
        listeners["\(type)-\(source)"] = listener
    }

    func dispatch(event: Event) {
        dispatchedEvents += [event]
        if event.source == "com.adobe.eventsource.media.requesttracker" || event.source == "com.adobe.eventsource.media.trackmedia" {
            // if this is a create tracker or track media request the event needs to be dispatched to the Media Extension
            simulateComingEvent(event: event)
        }
    }

    func createSharedState(data: [String: Any], event _: Event?) {
        createdSharedStates += [data]
    }

    func createPendingSharedState(event _: Event?) -> SharedStateResolver {
        return { data in
            self.createdSharedStates += [data]
        }
    }

    func getSharedState(extensionName: String, event: Event?, barrier: Bool) -> SharedStateResult? {
        let state = self.otherSharedStates["\(extensionName)-\(String(describing: event?.id))"] ?? nil
        if state == nil && event != nil {
            return self.otherSharedStates["\(extensionName)-nil"] ?? nil
        }
        return state
    }

    func getXDMSharedState(extensionName: String, event: Event?, barrier: Bool) -> SharedStateResult? {
        // no-op
        return nil
    }

    public func createXDMSharedState(data: [String: Any], event: Event?) {
        createdXdmSharedStates += [data]
    }

    func createPendingXDMSharedState(event: Event?) -> SharedStateResolver {
        return { data in
            self.createdXdmSharedStates += [data]
        }
    }

    public func getXDMSharedState(extensionName: String, event: Event?) -> SharedStateResult? {
        return otherXDMSharedStates["\(extensionName)-\(String(describing: event?.id))"] ?? nil
    }

    func simulateSharedState(extensionName: String, event: Event?, data: (value: [String: Any]?, status: SharedStateStatus)) {
        dispatchQueue.async {
            self.otherSharedStates["\(extensionName)-\(String(describing: event?.id))"] = SharedStateResult(status: data.status, value: data.value)
        }

    }

    public func simulateXDMSharedState(for extensionName: String, data: (value: [String: Any]?, status: SharedStateStatus)) {
        otherXDMSharedStates["\(extensionName)"] = SharedStateResult(status: data.status, value: data.value)
    }

    /// clear the events and shared states that have been created by the current extension
    public func resetDispatchedEventAndCreatedSharedStates() {
        dispatchedEvents = []
        createdSharedStates = []
    }

    func startEvents() {}

    func stopEvents() {}
}
