//
//  Exercise.swift
//  Triangle
//
//  Created by Dillon Reilly on 02/02/2025.
//

import SwiftUI

protocol Exercise {
    var id: Int { get }
    var title: String { get }
    var description: String { get }
    var isCompleted: Bool { get set }
    
    func startExercise(onComplete: @escaping () -> Void) -> AnyView
}
