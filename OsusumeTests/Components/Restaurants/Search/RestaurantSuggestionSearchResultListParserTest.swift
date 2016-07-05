import XCTest
import Nimble
@testable import Osusume

class RestaurantSuggestionSearchResultListParserTest: XCTestCase {
    var parser: RestaurantSuggestionSearchResultListParser!

    override func setUp() {
        parser = RestaurantSuggestionSearchResultListParser()
    }

    func test_parse_parsesListOfSearchResultRestaurants() {
        let json: [AnyObject] = [
            [
                "name": "Afuri",
                "address": "Address of Afuri",
                "place_id": "abcd",
                "latitude": 1.23,
                "longitude": 2.34
            ],
            [
                "name": "Fuji Soba",
                "address": "Address of Fuji Soba",
                "place_id": "efgh",
                "latitude": 3.45,
                "longitude": 4.56
            ]
        ]

        
        let restaurantSearchResult = parser.parse(json)


        let restaurantList = restaurantSearchResult.value!
        expect(restaurantList.count).to(equal(2))
        expect(restaurantList.first?.name).to(equal("Afuri"))
        expect(restaurantList.first?.address).to(equal("Address of Afuri"))
        expect(restaurantList.first?.placeId).to(equal("abcd"))
        expect(restaurantList.first?.latitude).to(equal(1.23))
        expect(restaurantList.first?.longitude).to(equal(2.34))
        expect(restaurantList.last?.name).to(equal("Fuji Soba"))
        expect(restaurantList.last?.address).to(equal("Address of Fuji Soba"))
        expect(restaurantList.last?.placeId).to(equal("efgh"))
        expect(restaurantList.last?.latitude).to(equal(3.45))
        expect(restaurantList.last?.longitude).to(equal(4.56))
    }

    func test_parsesEmptyAddressJson_excludesIncompleteResultList() {
        let json: [AnyObject] = [
            [
                "name": "Afuri",
                "address": "",
                "place_id": "abcd",
                "latitude": 1.23,
                "longitude": 2.34
            ],
            [
                "name": "Fuji Soba",
                "address": "Address of Fuji Soba",
                "place_id": "efgh",
                "latitude": 3.45,
                "longitude": 4.56
            ]
        ]


        let restaurantSearchResult = parser.parse(json)


        let restaurantList = restaurantSearchResult.value!
        expect(restaurantList.count).to(equal(1))
        expect(restaurantList.first?.name).to(equal("Fuji Soba"))
        expect(restaurantList.first?.address).to(equal("Address of Fuji Soba"))
        expect(restaurantList.first?.placeId).to(equal("efgh"))
        expect(restaurantList.first?.latitude).to(equal(3.45))
        expect(restaurantList.first?.longitude).to(equal(4.56))
    }

    func test_parseEmptyNameJson_excludesIncompleteResultList() {
        let json: [AnyObject] = [
            [
                "name": "",
                "address": "Address of Afuri",
                "place_id": "abcd",
                "latitude": 1.23,
                "longitude": 2.34
            ],
            [
                "name": "Fuji Soba",
                "address": "Address of Fuji Soba",
                "place_id": "efgh",
                "latitude": 3.45,
                "longitude": 4.56
            ]
        ]


        let restaurantSearchResult = parser.parse(json)


        let restaurantList = restaurantSearchResult.value!
        expect(restaurantList.count).to(equal(1))
        expect(restaurantList.first?.name).to(equal("Fuji Soba"))
        expect(restaurantList.first?.address).to(equal("Address of Fuji Soba"))
        expect(restaurantList.first?.placeId).to(equal("efgh"))
        expect(restaurantList.first?.latitude).to(equal(3.45))
        expect(restaurantList.first?.longitude).to(equal(4.56))
    }

    func test_parseEmptyResult_returnsEmptyList() {
        let json: [String : AnyObject] = [:]


        let restaurantSearchResult = parser.parse(json)


        expect(restaurantSearchResult.value?.count).to(equal(0))
    }
}
