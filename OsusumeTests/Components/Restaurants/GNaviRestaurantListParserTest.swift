import XCTest
import Nimble
@testable import Osusume

class GNaviRestaurantListParserTest: XCTestCase {
    var parser: GNaviRestaurantListParser!

    override func setUp() {
        parser = GNaviRestaurantListParser()
    }

    func test_parse_parsesListOfSearchResultRestaurants() {
        let json: [String: AnyObject] = [
            "rest": [
                [
                    "id": "1",
                    "name": "Afuri",
                    "address": "Address of Afuri"
                ],
                [
                    "id": "2",
                    "name": "Fuji Soba",
                    "address": "Address of Fuji Soba"
                ]
            ]
        ]

        
        let restaurantSearchResult = parser.parseGNaviResponse(json)


        let restaurantList = restaurantSearchResult.value!
        expect(restaurantList.count).to(equal(2))
        expect(restaurantList.first?.id).to(equal("1"))
        expect(restaurantList.first?.name).to(equal("Afuri"))
        expect(restaurantList.first?.address).to(equal("Address of Afuri"))
        expect(restaurantList.last?.id).to(equal("2"))
        expect(restaurantList.last?.name).to(equal("Fuji Soba"))
        expect(restaurantList.last?.address).to(equal("Address of Fuji Soba"))
    }

    func test_parsesEmptyAddressJson_excludesIncompleteResultList() {
        let json: [String: AnyObject] = [
            "rest": [
                [
                    "id": "1",
                    "name": "Afuri",
                    "address": ""
                ],
                [
                    "id": "2",
                    "name": "Fuji Soba",
                    "address": "Address of Fuji Soba"
                ]
            ]
        ]


        let restaurantSearchResult = parser.parseGNaviResponse(json)


        let restaurantList = restaurantSearchResult.value!
        expect(restaurantList.count).to(equal(1))
        expect(restaurantList.first?.id).to(equal("2"))
        expect(restaurantList.first?.name).to(equal("Fuji Soba"))
        expect(restaurantList.first?.address).to(equal("Address of Fuji Soba"))
    }

    func test_parseEmptyNameJson_excludesIncompleteResultList() {
        let json: [String: AnyObject] = [
            "rest": [
                [
                    "id": "1",
                    "name": "",
                    "address": "Address of Afuri"
                ],
                [
                    "id": "2",
                    "name": "Fuji Soba",
                    "address": "Address of Fuji Soba"
                ]
            ]
        ]


        let restaurantSearchResult = parser.parseGNaviResponse(json)


        let restaurantList = restaurantSearchResult.value!
        expect(restaurantList.count).to(equal(1))
        expect(restaurantList.first?.id).to(equal("2"))
        expect(restaurantList.first?.name).to(equal("Fuji Soba"))
        expect(restaurantList.first?.address).to(equal("Address of Fuji Soba"))
    }

    func test_parseEmptyResult_returnsEmptyList() {
        let json: [String : AnyObject] = [:]


        let restaurantSearchResult = parser.parseGNaviResponse(json)


        expect(restaurantSearchResult.value?.count).to(equal(0))
    }
}
