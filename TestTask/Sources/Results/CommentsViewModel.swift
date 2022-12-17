//
//  CommentsViewModel.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 17.12.2022.
//

import Foundation

protocol CommentsViewModelProtocol: AnyObject {
    var comments: [CommentResponse] { get }
    func loadInitialComments()
    func loadNextPageIfNeeded()
}

final class CommentsViewModel: CommentsViewModelProtocol {
    // MARK: - Properties
    weak var viewController: CommentsViewControllerProtocol?
    private(set) var comments: [CommentResponse] = []

    private let lowerBound: Int
    private let upperBound: Int
    private var commentsAPI: CommentsAPIProtocol

    private var dispatchGroup = DispatchGroup()

    private let limitPerPage: Int = 10

    private lazy var totalNumberOfPages: Int = {
        var result = (Double(upperBound - lowerBound) / Double(limitPerPage))
        result.round(.up)
        return Int(result)
    }()

    private var nextPageRange: Range<Int> {
        let lowerRangeBound = lowerBound + comments.count
        let nextCount = lowerRangeBound + limitPerPage
        if nextCount <= upperBound {
            return lowerRangeBound..<nextCount
        } else {
            return lowerRangeBound..<upperBound + 1
        }
    }
    private var isLoading = false

    private var currentPageComments: [CommentResponse] = []

    // MARK: Life cycle
    init(lowerBound: Int, upperBound: Int) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.commentsAPI = CommentsAPI()
    }

    // MARK: - Internal methods
    func loadInitialComments() {
        loadNextPageIfNeeded()
    }

    func loadNextPageIfNeeded() {
        guard !isLoading else { return }

        let currentPageRange = nextPageRange

        guard currentPageRange.lowerBound - 1 < upperBound else { return }

        isLoading = true

        viewController?.showTableFooterSpinner()

        for i in currentPageRange {
            dispatchGroup.enter()
            commentsAPI.getComments(commentId: i) { [weak self] response in
                self?.currentPageComments.append(response)
                self?.dispatchGroup.leave()
            } failed: { [weak self] error in
                self?.dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let sortedComments = self.currentPageComments.sorted(by: { $0.id < $1.id })

            self.isLoading = false

            let currentCommentsCount = self.comments.count
            let newIndexPathsRange = currentCommentsCount..<currentCommentsCount + sortedComments.count

            self.comments.append(contentsOf: sortedComments)
            self.currentPageComments.removeAll()

            self.viewController?.hideTableFooterSpinner()
            let indexPaths = newIndexPathsRange.map { IndexPath(item: $0, section: 0) }
            self.viewController?.insertRows(at: indexPaths)
        }
    }
}
