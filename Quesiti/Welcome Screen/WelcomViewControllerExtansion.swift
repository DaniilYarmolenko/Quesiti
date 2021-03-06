//
//  WelcomViewControllerExtansion.swift
//  Quesiti
//
//  Created by Даниил Ярмоленко on 24.10.2021.
//

import UIKit

extension WelcomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
   
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let xValue = targetContentOffset.pointee.x
        let pageNum = Int(xValue / view.frame.width)
        pageControl.currentPage = pageNum
        if pageNum != welcomePages.count - 1{
            skipButton.isHidden = false
        }else{
            goToSignInController()
            skipButton.isHidden = true
        }
        if pageControl.currentPage > 0 { slideAnimView.isHidden = true } else { slideAnimView.isHidden = false }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return welcomePages.count
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! WelcomCell
        let welcomePage = welcomePages[indexPath.row]
        cell.page = welcomePage
        cell.welcomeViewController = self
        return cell
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let welcomeCell = cell as! WelcomCell
        welcomeCell.topicImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        welcomeCell.descriptionLabel.transform = CGAffineTransform(translationX: view.frame.origin.x + view.frame.width/2, y: 0)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            welcomeCell.topicImage.transform = .identity
            welcomeCell.descriptionLabel.transform = .identity
        })
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

