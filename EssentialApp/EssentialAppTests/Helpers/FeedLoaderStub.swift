//
//  FeedLoaderStub.swift
//  EssentialApp
//
//  Created by Hugo Vanderlei on 29/12/25.
//


import EssentialFeed

class FeedLoaderStub: FeedLoader {
	private let result: FeedLoader.Result

	init(result: FeedLoader.Result) {
		self.result = result
	}

	func load(completion: @escaping (FeedLoader.Result) -> Void) {
		completion(result)
	}
}