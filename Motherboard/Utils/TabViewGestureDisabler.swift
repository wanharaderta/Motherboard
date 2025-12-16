//
//  TabViewGestureDisabler.swift
//  Motherboard
//
//  Created by Wanhar on 14/12/25.
//

import SwiftUI
import UIKit

struct TabViewGestureDisabler: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            // Find the TabView's UIPageViewController and disable its gestures
            if let parent = uiView.superview {
                disableTabViewGestures(in: parent)
            }
        }
    }
    
    private func disableTabViewGestures(in view: UIView) {
        // Recursively find UIPageViewController
        for subview in view.subviews {
            // Check if this subview contains a UIPageViewController
            if let pageViewController = findPageViewController(in: subview) {
                // Disable all pan gesture recognizers
                for gestureRecognizer in pageViewController.gestureRecognizers ?? [] {
                    if gestureRecognizer is UIPanGestureRecognizer {
                        gestureRecognizer.isEnabled = false
                    }
                }
            }
            // Also check scroll views that might be used by TabView
            if let scrollView = subview as? UIScrollView {
                scrollView.isScrollEnabled = false
            }
            disableTabViewGestures(in: subview)
        }
    }
    
    private func findPageViewController(in view: UIView) -> UIPageViewController? {
        // Check the view itself
        var responder: UIResponder? = view
        while responder != nil {
            if let pageViewController = responder as? UIPageViewController {
                return pageViewController
            }
            responder = responder?.next
        }
        return nil
    }
}
