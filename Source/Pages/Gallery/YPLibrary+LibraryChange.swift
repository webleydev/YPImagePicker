//
//  YPLibrary+LibraryChange.swift
//  YPImagePicker
//
//  Created by Sacha DSO on 26/01/2018.
//  Copyright © 2018 Yummypets. All rights reserved.
//

import UIKit
import Photos

extension YPLibraryVC: PHPhotoLibraryChangeObserver {
    func registerForLibraryChanges() {
        PHPhotoLibrary.shared().register(self)
    }
    
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            let fetchResult = self.mediaManager.fetchResult!
            let collectionChanges = changeInstance.changeDetails(for: fetchResult)
            if collectionChanges != nil {
                self.mediaManager.fetchResult = collectionChanges!.fetchResultAfterChanges
                self.updateSelectionForChangedItems()
                let collectionView = self.v.collectionView!
                if !collectionChanges!.hasIncrementalChanges || collectionChanges!.hasMoves {
                    collectionView.reloadData()
                } else {
                    collectionView.performBatchUpdates({
                        let removedIndexes = collectionChanges!.removedIndexes?.map({ (fetchResult.count - 1) - $0 })
                        let removedIndexSet = IndexSet(removedIndexes ?? [])
                        if (removedIndexes?.count ?? 0) != 0 {
                            collectionView.deleteItems(at: removedIndexSet.aapl_indexPathsFromIndexesWithSection(0))
                        }
                        let insertedIndexes = collectionChanges!.insertedIndexes?.map({
                            self.actualInsertedIndex(from: collectionChanges!.fetchResultAfterChanges, index: $0)
                        })
                        let insertedIndexSet = IndexSet(insertedIndexes ?? [])
                        if (insertedIndexes?.count ?? 0) != 0 {
                            collectionView.insertItems(at: insertedIndexSet.aapl_indexPathsFromIndexesWithSection(0))
                        }
                    }, completion: { finished in
                        if finished {
                            let changedIndexes = collectionChanges!.changedIndexes?.map({
                                (collectionChanges!.fetchResultAfterChanges.count - 1) - $0
                            })
                            let changedIndexSet = IndexSet(changedIndexes ?? [])
                            if (changedIndexes?.count ?? 0) != 0 {
                                collectionView.reloadItems(at: changedIndexSet.aapl_indexPathsFromIndexesWithSection(0))
                            }
                        }
                    })
                }
                self.mediaManager.resetCachedAssets()
            }
        }
    }
    
    private func actualInsertedIndex(from fetchResult: PHFetchResult<PHAsset>, index: Int) -> Int {
        if fetchResult.count - 1 > index {
            return (fetchResult.count - 1) - index
        }
        return index - (fetchResult.count - 1)
    }
}
