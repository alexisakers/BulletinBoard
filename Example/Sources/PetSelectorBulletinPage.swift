/**
 *  Bulletin
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import Bulletin

class PetSelectorBulletinPage: BulletinItem {

    var manager: BulletinManager?
    var isDismissable: Bool = false

    private var catButtonContainer: ContainerView<UIButton>!
    private var dogButtonContainer: ContainerView<UIButton>!
    private var saveButtonContainer: ContainerView<HighlightButton>!

    func makeArrangedSubviews() -> [UIView] {

        var arrangedSubviews = [UIView]()
        let favoriteTabIndex = BulletinDataSource.favoriteTabIndex

        // Title Label

        let titleLabel = UILabel()
        titleLabel.text = "Choose your Favorite"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        titleLabel.textColor = #colorLiteral(red: 0.568627451, green: 0.5647058824, blue: 0.5725490196, alpha: 1)
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center

        arrangedSubviews.append(titleLabel)

        // Description Label

        let descriptionLabel = UILabel()
        descriptionLabel.text = "Your favorite pets will appear when you open the app."
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 20)

        arrangedSubviews.append(descriptionLabel)

        // Pets Stack

        let petsStack = UIStackView()
        petsStack.axis = .vertical
        petsStack.alignment = .fill
        petsStack.distribution = .fill
        petsStack.spacing = 16

        // Cat Button

        let catButton = UIButton(type: .system)
        catButton.setTitle("🐱 Cats", for: .normal)
        catButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        catButton.contentHorizontalAlignment = .center

        catButtonContainer = ContainerView<UIButton>(catButton)
        catButtonContainer.layer.cornerRadius = 12
        catButtonContainer.layer.borderWidth = 2

        catButtonContainer.heightAnchor.constraint(equalToConstant: 55).isActive = true

        let catButtonColor = (favoriteTabIndex == 0) ? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) : .lightGray
        catButtonContainer.layer.borderColor = catButtonColor.cgColor
        catButton.setTitleColor(catButtonColor, for: .normal)

        catButton.addTarget(self, action: #selector(catButtonTapped), for: .touchUpInside)

        petsStack.addArrangedSubview(catButtonContainer)

        // Dog Button

        let dogButton = UIButton(type: .system)
        dogButton.setTitle("🐶 Dogs", for: .normal)
        dogButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        dogButton.contentHorizontalAlignment = .center

        dogButton.addTarget(self, action: #selector(dogButtonTapped), for: .touchUpInside)

        dogButtonContainer = ContainerView<UIButton>(dogButton)
        dogButtonContainer.layer.cornerRadius = 12
        dogButtonContainer.layer.borderWidth = 2

        dogButtonContainer.heightAnchor.constraint(equalToConstant: 55).isActive = true

        let dogButtonColor = (favoriteTabIndex == 1) ? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) : .lightGray
        dogButtonContainer.layer.borderColor = dogButtonColor.cgColor
        dogButton.setTitleColor(dogButtonColor, for: .normal)

        petsStack.addArrangedSubview(dogButtonContainer)

        arrangedSubviews.append(petsStack)

        // Save Button

        let saveButton = HighlightButton(type: .custom)
        saveButton.setBackgroundColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), forState: .normal)
        saveButton.contentHorizontalAlignment = .center
        saveButton.autoresizingMask = .flexibleWidth
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true

        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        saveButtonContainer = ContainerView<HighlightButton>(saveButton)
        saveButtonContainer.heightAnchor.constraint(equalToConstant: 55).isActive = true

        arrangedSubviews.append(saveButtonContainer)

        return arrangedSubviews

    }

    func tearDown() {
        catButtonContainer?.contentView.removeTarget(self, action: nil, for: .touchUpInside)
        dogButtonContainer?.contentView.removeTarget(self, action: nil, for: .touchUpInside)
        saveButtonContainer?.contentView.removeTarget(self, action: nil, for: .touchUpInside)
    }

    @objc func catButtonTapped() {

        let catButtonColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        catButtonContainer?.layer.borderColor = catButtonColor.cgColor
        catButtonContainer?.contentView.setTitleColor(catButtonColor, for: .normal)

        let dogButtonColor = UIColor.lightGray
        dogButtonContainer?.layer.borderColor = dogButtonColor.cgColor
        dogButtonContainer?.contentView.setTitleColor(dogButtonColor, for: .normal)

        NotificationCenter.default.post(name: .FavoriteTabIndexDidChange,
                                        object: self,
                                        userInfo: ["Index": 0])

    }

    @objc func dogButtonTapped() {

        let catButtonColor = UIColor.lightGray
        catButtonContainer?.layer.borderColor = catButtonColor.cgColor
        catButtonContainer?.contentView.setTitleColor(catButtonColor, for: .normal)

        let dogButtonColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        dogButtonContainer?.layer.borderColor = dogButtonColor.cgColor
        dogButtonContainer?.contentView.setTitleColor(dogButtonColor, for: .normal)

        NotificationCenter.default.post(name: .FavoriteTabIndexDidChange,
                                        object: self,
                                        userInfo: ["Index": 1])

    }

    @objc func saveButtonTapped() {
        manager?.displayNextItem()
    }

}
