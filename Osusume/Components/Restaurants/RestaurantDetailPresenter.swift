struct RestaurantDetailPresenter {
    let restaurant: Restaurant

    var name: String {
        return restaurant.name
    }

    var address: String {
        return restaurant.address
    }

    var cuisineType: String {
        return "Cuisine: \(restaurant.cuisine.name)"
    }

    var notes: String {
        return self.restaurant.notes
    }

    var creationInfo: String {
        return "Added by \(restaurant.createdByUser.name) on \(DateConverter.formattedDate(restaurant.createdAt))"
    }

    var author: String {
        return "Added by \(restaurant.createdByUser.name)"
    }

    var creationDate: String {
        return "Created on \(DateConverter.formattedDate(restaurant.createdAt))"
    }

    var photoUrl: NSURL {
        if let photoUrl = self.restaurant.photoUrls.first {
            return photoUrl.url
        }

        return NSURL(string: "")!
    }

    var numberOfLikes: String {
        let numberOfLikes = restaurant.numberOfLikes

        let numberOfPeopleQualifier = numberOfLikes == 1 ? "person" : "people"

        return "\(numberOfLikes) \(numberOfPeopleQualifier) liked"
    }

    var priceRange: String {
        return "Price Range: \(restaurant.priceRange.range)"
    }
}
