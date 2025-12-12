 private func uniqueImage() -> FeedImage {
        return FeedImage(
            id: UUID(),
            description: "any",
            location: "any",
            url: anyURL()
        )
    }

    private func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
        let models = [uniqueImage(), uniqueImage()]
        let local = models.map { LocalFeedImage(
            id: $0.id,
            description: $0.description,
            location: $0.location,
            url: $0.url
        ) }

        return (models, local)
    }

    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }

    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }