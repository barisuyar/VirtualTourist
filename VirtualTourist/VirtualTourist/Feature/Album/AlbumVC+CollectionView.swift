//
//  AlbumVC+CollectionView.swift
//  VirtualTourist
//
//  Created by BARIS UYAR on 12.01.2022.
//

import UIKit

extension AlbumVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        fetchedResultsController?.sections?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        setupFetchedResultsController()
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return .init() }

        let placeholderImage = UIImage(systemName: "photo")
        cell.imageView.image = placeholderImage

        guard let cellPhoto = fetchedResultsController?.object(at: indexPath) else { return cell }
        if let image = cellPhoto.image {
            cell.activityIndicator.isHidden = true
            cell.activityIndicator.stopAnimating()
            noImageLabel.isHidden = true
            renewButton.isEnabled = true
            cell.imageView.image = UIImage(data: image)
        } else if let imageUrlString = cellPhoto.url,
                  let imageUrl = URL(string: imageUrlString) {
            renewButton.isEnabled = false
            cell.activityIndicator.startAnimating()
            FlickerClient.downloadPhotos(imageURL: imageUrl) { [weak self] (data, error) in
                cell.activityIndicator.isHidden = true
                cell.activityIndicator.stopAnimating()
                self?.renewButton.isEnabled = true
                guard let data = data,
                      let image = UIImage(data: data) else { return }
                cellPhoto.image = data
                cell.imageView.image = image
                try? DataController.shared.viewContext.save()
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let objectSelected = fetchedResultsController?.object(at: indexPath) else { return }
        let context = DataController.shared.viewContext
        context.delete(objectSelected)
        if var photos = fetchedResultsController?.fetchedObjects {
            photos.remove(at: indexPath.row)
        }
        try? context.save()
        setupFetchedResultsController()
        collectionView.reloadData()
    }
}
