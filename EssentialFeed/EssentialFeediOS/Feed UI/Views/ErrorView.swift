//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Hugo Vanderlei on 09/12/25.
//  Copyright © 2025 Essential Developer. All rights reserved.
//
import UIKit

// MARK: - ErrorView

public final class ErrorView: UIView {

    // MARK: Properties

    @IBOutlet private var label: UILabel!

    // MARK: Computed Properties

    public var message: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    // MARK: Overridden Functions

    override public func awakeFromNib() {
        super.awakeFromNib()

        label.text = nil
    }
}
