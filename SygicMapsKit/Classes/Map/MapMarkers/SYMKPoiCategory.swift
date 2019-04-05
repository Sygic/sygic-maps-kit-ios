//// SYMKPoiCategory.swift
//
// Copyright (c) 2019 - Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the &quot;Software&quot;), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import SygicUIKit
import SygicMaps


/// Helper class responsible for mapping SYPoiCategory to icon and color identical to icons and colors used in SYMapView engine.
public class SYMKPoiCategory {

    // MARK: - Public Properties
    
    /// Icon of a point of interest category.
    public let icon: String
    /// Color of a point of interest category.
    public let color: UIColor
    
    // MARK: - Public Methods
    
    public init(icon: String, color: UIColor?) {
        self.icon = icon
        self.color = color ?? .textBody
    }
    
    /// Returns specific category icon and color for `SYPoiCategory`.
    ///
    /// - Parameter syPoiCategory: Point of interest category defined by SDK.
    /// - Returns: `SYMKPoiCategory` object with specific icon and color for a `SYPoiCategory`.
    public class func with(syPoiCategory: SYPoiCategory) -> SYMKPoiCategory {
        switch syPoiCategory {
        case .unknown: return SYMKPoiCategory(icon: SYUIIcon.pinPlace, color: .textBody)
            
        //Tourism
        case .tourist_Information_Office: return SYMKPoiCategory(icon: SYUIIcon.infoCenter, color: .poiGroupTourism)
        case .museum: return SYMKPoiCategory(icon: SYUIIcon.museum, color: .poiGroupTourism)
        case .zoo: return SYMKPoiCategory(icon: SYUIIcon.zoo, color: .poiGroupTourism)
        case .scenic_Panoramic_View: return SYMKPoiCategory(icon: SYUIIcon.mountines, color: .poiGroupTourism)
        case .camping_Ground: return SYMKPoiCategory(icon: SYUIIcon.camp, color: .poiGroupTourism)
        case .caravan_Site: return SYMKPoiCategory(icon: SYUIIcon.caravan, color: .poiGroupTourism)
        case .recreation_Facility: return SYMKPoiCategory(icon: SYUIIcon.spa, color: .poiGroupTourism)
        case .beach: return SYMKPoiCategory(icon: SYUIIcon.beach, color: .poiGroupTourism)
        case .mountain_Peak: return SYMKPoiCategory(icon: SYUIIcon.peak, color: .poiGroupTourism)
        case .castle: return SYMKPoiCategory(icon: SYUIIcon.chateau, color: .poiGroupTourism)
        case .fortress: return SYMKPoiCategory(icon: SYUIIcon.stronghold, color: .poiGroupTourism)
        case .holiday_Area: return SYMKPoiCategory(icon: SYUIIcon.beach, color: .poiGroupTourism)
        case .monument: return SYMKPoiCategory(icon: SYUIIcon.monument, color: .poiGroupTourism)
        case .natural_Reserve: return SYMKPoiCategory(icon: SYUIIcon.forest, color: .poiGroupTourism)
        case .mountain_Pass: return SYMKPoiCategory(icon: SYUIIcon.peak, color: .poiGroupTourism)
        case .park_and_Recreation_Area: return SYMKPoiCategory(icon: SYUIIcon.park, color: .poiGroupTourism)
        case .forest_Area: return SYMKPoiCategory(icon: SYUIIcon.forest, color: .poiGroupTourism)
        case .natives_Reservation, .building_Footprint, .travel_Agency, .lighthouse, .rocks, .walking_Area, .water_Mill, .windmill, .archeology, .important_Tourist_Attraction:
            return SYMKPoiCategory(icon: SYUIIcon.attraction, color: .poiGroupTourism)
            
        //Food and Drink
        case .winery: return SYMKPoiCategory(icon: SYUIIcon.wine, color: .poiGroupFoodDrink)
        case .road_Side_Diner: return SYMKPoiCategory(icon: SYUIIcon.food, color: .poiGroupFoodDrink)
        case .restaurant_Area: return SYMKPoiCategory(icon: SYUIIcon.restaurant, color: .poiGroupFoodDrink)
        case .cafe_Pub: return SYMKPoiCategory(icon: SYUIIcon.cafe, color: .poiGroupFoodDrink)
        case .pastry_and_Sweets: return SYMKPoiCategory(icon: SYUIIcon.patisserie, color: .poiGroupFoodDrink)
        case .restaurant: return SYMKPoiCategory(icon: SYUIIcon.restaurant, color: .poiGroupFoodDrink)
        case .food: return SYMKPoiCategory(icon: SYUIIcon.food, color: .poiGroupFoodDrink)
            
        //Accomodation
        case .hotel_or_Motel: return SYMKPoiCategory(icon: SYUIIcon.accomodation, color: .poiGroupAccomodation)
            
        //Parking
        case .rent_a_Car_Parking: return SYMKPoiCategory(icon: SYUIIcon.carRental, color: .poiGroupParking)
        case .parking_Garage: return SYMKPoiCategory(icon: SYUIIcon.parkingHouse, color: .poiGroupParking)
        case .coach_and_Lorry_Parking, .open_Parking_Area:
            return SYMKPoiCategory(icon: SYUIIcon.parking, color: .poiGroupParking)
            
        //Petrol station
        case .petrol_Station: return SYMKPoiCategory(icon: SYUIIcon.stationPetrol, color: .poiGroupPetrolStation)
            
        //Transportation
        case .ski_Lift_Station: return SYMKPoiCategory(icon: SYUIIcon.cableway, color: .poiGroupTransportation)
        case .car_Shipping_Terminal: return SYMKPoiCategory(icon: SYUIIcon.carCarrier, color: .poiGroupTransportation)
        case .airport: return SYMKPoiCategory(icon: SYUIIcon.plane, color: .poiGroupTransportation)
        case .bus_Station: return SYMKPoiCategory(icon: SYUIIcon.bus, color: .poiGroupTransportation)
        case .port: return SYMKPoiCategory(icon: SYUIIcon.harbor, color: .poiGroupTransportation)
        case .ferry_Terminal: return SYMKPoiCategory(icon: SYUIIcon.boat, color: .poiGroupTransportation)
        case .airline_Access: return SYMKPoiCategory(icon: SYUIIcon.terminal, color: .poiGroupTransportation)
        case .railway_Station: return SYMKPoiCategory(icon: SYUIIcon.train, color: .poiGroupTransportation)
        case .public_Transport_Stop: return SYMKPoiCategory(icon: SYUIIcon.publicTransportStop, color: .poiGroupTransportation)
        case .metro: return SYMKPoiCategory(icon: SYUIIcon.subway, color: .poiGroupTransportation)
            
        //Bank
        case .bank: return SYMKPoiCategory(icon: SYUIIcon.bank, color: .poiGroupBank)
        case .ATM: return SYMKPoiCategory(icon: SYUIIcon.ATM, color: .poiGroupBank)
            
        //Shopping
        case .department_Store: return SYMKPoiCategory(icon: SYUIIcon.supermarket, color: .poiGroupShopping)
        case .warehouse: return SYMKPoiCategory(icon: SYUIIcon.warehouse, color: .poiGroupShopping)
        case .groceries: return SYMKPoiCategory(icon: SYUIIcon.groceryStore, color: .poiGroupShopping)
        case .supermarket: return SYMKPoiCategory(icon: SYUIIcon.supermarket, color: .poiGroupShopping)
        case .accessories_Furniture: return SYMKPoiCategory(icon: SYUIIcon.furniture, color: .poiGroupShopping)
        case .books_Cards: return SYMKPoiCategory(icon: SYUIIcon.bookShop, color: .poiGroupShopping)
        case .children_Toys: return SYMKPoiCategory(icon: SYUIIcon.toyStore, color: .poiGroupShopping)
        case .cosmetics_Perfumes: return SYMKPoiCategory(icon: SYUIIcon.parfumes, color: .poiGroupShopping)
        case .gifts_Antiques: return SYMKPoiCategory(icon: SYUIIcon.presents, color: .poiGroupShopping)
        case .jewellery_Watches: return SYMKPoiCategory(icon: SYUIIcon.jewelery, color: .poiGroupShopping)
        case .lifestyle_Fitness: return SYMKPoiCategory(icon: SYUIIcon.fitness, color: .poiGroupShopping)
        case .shoes_Bags: return SYMKPoiCategory(icon: SYUIIcon.shoeStore, color: .poiGroupShopping)
        case .sports: return SYMKPoiCategory(icon: SYUIIcon.running, color: .poiGroupShopping)
            
        case .childrens_Fashion, .fashion_Mixed, .fashion_Accessories, .traditional_Fashion, .ladies_Fashion, .men_s_Fashion:
            return SYMKPoiCategory(icon: SYUIIcon.fashion, color: .poiGroupShopping)
            
        case .mobile_Shop, .electronics_Mobiles:
            return SYMKPoiCategory(icon: SYUIIcon.deviceIphone, color: .poiGroupShopping)
            
        case .shopping_Centre, .hair_And_Beauty, .shop, .opticians_Sunglasses:
            return SYMKPoiCategory(icon: SYUIIcon.shopping, color: .poiGroupShopping)
            
        //Vehicle services
        case .trafficLights: return SYMKPoiCategory(icon: SYUIIcon.trafficLights, color: .poiGroupVehicleServices)
        case .rent_a_Car_Facility: return SYMKPoiCategory(icon: SYUIIcon.carRental, color: .poiGroupVehicleServices)
        case .bovag_Garage: return SYMKPoiCategory(icon: SYUIIcon.parkingHouse, color: .poiGroupVehicleServices)
        case .rest_Area: return SYMKPoiCategory(icon: SYUIIcon.restingArea, color: .poiGroupVehicleServices)
        case .park_And_Ride: return SYMKPoiCategory(icon: SYUIIcon.parking, color: .poiGroupVehicleServices)
        case .speed_Cameras: return SYMKPoiCategory(icon: SYUIIcon.speedcam, color: .poiGroupVehicleServices)
            
        case .vehicle_Equipment_Provider, .car_Repair_Facility, .chevrolet_Car_Repair:
            return SYMKPoiCategory(icon: SYUIIcon.serviceStation, color: .poiGroupVehicleServices)
            
        case .motoring_Organization_Office, .car_Dealer, .car_Services, .chevrolet_Car_Dealer:
            return SYMKPoiCategory(icon: SYUIIcon.vehicle, color: .poiGroupVehicleServices)
            
        //Social life
        case .casino: return SYMKPoiCategory(icon: SYUIIcon.casino, color: .poiGroupSocialLife)
        case .cinema: return SYMKPoiCategory(icon: SYUIIcon.cinema, color: .poiGroupSocialLife)
        case .opera: return SYMKPoiCategory(icon: SYUIIcon.opera, color: .poiGroupSocialLife)
        case .leisure_Centre: return SYMKPoiCategory(icon: SYUIIcon.spa, color: .poiGroupSocialLife)
        case .nightlife: return SYMKPoiCategory(icon: SYUIIcon.bar, color: .poiGroupSocialLife)
        case .general: return SYMKPoiCategory(icon: SYUIIcon.pinPlace, color: .poiGroupSocialLife)
        case .amusement_Park: return SYMKPoiCategory(icon: SYUIIcon.amusementPark, color: .poiGroupSocialLife)
        case .arts_Centre: return SYMKPoiCategory(icon: SYUIIcon.gallery, color: .poiGroupSocialLife)
        case .library: return SYMKPoiCategory(icon: SYUIIcon.library, color: .poiGroupSocialLife)
        case .ecotourism_Sites: return SYMKPoiCategory(icon: SYUIIcon.forest, color: .poiGroupSocialLife)
        case .hunting_Shop: return SYMKPoiCategory(icon: SYUIIcon.supermarket, color: .poiGroupSocialLife)
        case .kids_Place: return SYMKPoiCategory(icon: SYUIIcon.playGround, color: .poiGroupSocialLife)
        case .mosque: return SYMKPoiCategory(icon: SYUIIcon.mosque, color: .poiGroupSocialLife)
        case .place_of_Worship: return SYMKPoiCategory(icon: SYUIIcon.pray, color: .poiGroupSocialLife)
            
        case .abbey, .church, .monastery:
            return SYMKPoiCategory(icon: SYUIIcon.church, color: .poiGroupSocialLife)
            
        case .concert_Hall, .music_Centre:
            return SYMKPoiCategory(icon: SYUIIcon.philharmonic, color: .poiGroupSocialLife)
            
        case .theatre, .cultural_Centre, .entertainment:
            return SYMKPoiCategory(icon: SYUIIcon.theater, color: .poiGroupSocialLife)
            
        //Services and education
        case .post_Office: return SYMKPoiCategory(icon: SYUIIcon.postOffice, color: .poiGroupSvcEducation)
        case .public_Phone: return SYMKPoiCategory(icon: SYUIIcon.call, color: .poiGroupSvcEducation)
        case .transport_Company: return SYMKPoiCategory(icon: SYUIIcon.truck, color: .poiGroupSvcEducation)
        case .cargo_Centre: return SYMKPoiCategory(icon: SYUIIcon.warehouse, color: .poiGroupSvcEducation)
        case .school: return SYMKPoiCategory(icon: SYUIIcon.schoolZone, color: .poiGroupSvcEducation)
        case .toll: return SYMKPoiCategory(icon: SYUIIcon.avoidTollRoads, color: .poiGroupSvcEducation)
        case .college_University: return SYMKPoiCategory(icon: SYUIIcon.school, color: .poiGroupSvcEducation)
        case .kindergarten: return SYMKPoiCategory(icon: SYUIIcon.kindergarten, color: .poiGroupSvcEducation)
        case .courthouse: return SYMKPoiCategory(icon: SYUIIcon.court, color: .poiGroupSvcEducation)
        case .convention_Centre: return SYMKPoiCategory(icon: SYUIIcon.conferenceHall, color: .poiGroupSvcEducation)
        case .prison: return SYMKPoiCategory(icon: SYUIIcon.jail, color: .poiGroupSvcEducation)
        case .state_Police_Office: return SYMKPoiCategory(icon: SYUIIcon.police, color: .poiGroupSvcEducation)
        case .agricultural_Industry: return SYMKPoiCategory(icon: SYUIIcon.farm, color: .poiGroupSvcEducation)
        case .medical_Material: return SYMKPoiCategory(icon: SYUIIcon.drugStore, color: .poiGroupSvcEducation)
        case .personal_Services: return SYMKPoiCategory(icon: SYUIIcon.profile, color: .poiGroupSvcEducation)
        case .military_Installation: return SYMKPoiCategory(icon: SYUIIcon.army, color: .poiGroupSvcEducation)
        case .cash_Dispenser: return SYMKPoiCategory(icon: SYUIIcon.money, color: .poiGroupSvcEducation)
            
        case .exchange, .money_Transfer:
            return SYMKPoiCategory(icon: SYUIIcon.moneyExchange, color: .poiGroupSvcEducation)
            
        case .cemetery, .military_Cemetery:
            return SYMKPoiCategory(icon: SYUIIcon.cemetery, color: .poiGroupSvcEducation)
            
        case .industrial_Building, .factories, .factory_Ground_Philips:
            return SYMKPoiCategory(icon: SYUIIcon.factory, color: .poiGroupSvcEducation)
            
        case .condominium, .commercial_Building, .real_Estate:
            return SYMKPoiCategory(icon: SYUIIcon.city, color: .poiGroupSvcEducation)
            
        case .freeport, .company, .construction, .media, .professionals, .services, .squares, .local_Names:
            return SYMKPoiCategory(icon: SYUIIcon.pinPlace, color: .poiGroupSvcEducation)
            
        case .customs, .frontier_Crossing, .border_Point:
            return SYMKPoiCategory(icon: SYUIIcon.borderCrossing, color: .poiGroupSvcEducation)
            
        case .community_Centre, .business_Facility, .exhibition_Centre, .government_Office:
            return SYMKPoiCategory(icon: SYUIIcon.office, color: .poiGroupSvcEducation)
            
        case .city_Hall, .embassy:
            return SYMKPoiCategory(icon: SYUIIcon.church, color: .poiGroupSvcEducation)
            
        //Sport
        case .tennis_Court: return SYMKPoiCategory(icon: SYUIIcon.tennis, color: .poiGroupSport)
        case .yacht_Basin: return SYMKPoiCategory(icon: SYUIIcon.harbor, color: .poiGroupSport)
        case .golf_Course: return SYMKPoiCategory(icon: SYUIIcon.golf, color: .poiGroupSport)
            
        case .ice_Skating_Rink, .skating_Rink:
            return SYMKPoiCategory(icon: SYUIIcon.running, color: .poiGroupSport)
            
        case .water_Sport, .swimming_Pool:
            return SYMKPoiCategory(icon: SYUIIcon.swimming, color: .poiGroupSport)
            
        case .sports_Centre, .stadium, .hippodrome, .sports_Hall, .car_Racetrack:
            return SYMKPoiCategory(icon: SYUIIcon.stadium, color: .poiGroupSport)
            
        //Guides
        case .wikipedia: return SYMKPoiCategory(icon: SYUIIcon.infoCenter, color: .poiGroupGuides)
            
        //Emergency
        case .police_Station: return SYMKPoiCategory(icon: SYUIIcon.police, color: .poiGroupEmergency)
        case .pharmacy: return SYMKPoiCategory(icon: SYUIIcon.drugStore, color: .poiGroupEmergency)
        case .emergency_Call_Station: return SYMKPoiCategory(icon: SYUIIcon.emergencyPhone, color: .poiGroupEmergency)
        case .fire_Brigade: return SYMKPoiCategory(icon: SYUIIcon.firefighters, color: .poiGroupEmergency)
        case .dentist: return SYMKPoiCategory(icon: SYUIIcon.dentist, color: .poiGroupEmergency)
        case .veterinarian: return SYMKPoiCategory(icon: SYUIIcon.vet, color: .poiGroupEmergency)
        case .breakdown_Service: return SYMKPoiCategory(icon: SYUIIcon.serviceStation, color: .poiGroupEmergency)
            
        case .first_Aid_Post, .emergency_Medical_Service:
            return SYMKPoiCategory(icon: SYUIIcon.ambulance, color: .poiGroupEmergency)
        case .hospital_Polyclinic, .doctor:
            return SYMKPoiCategory(icon: SYUIIcon.hospital, color: .poiGroupEmergency)
        }
    }
    
}

public class SYMKPoiGroup {
    public let name: String
    public let icon: String
    public let color: UIColor
    public let searchId: SYPoiGroup
    
    public init(name: String, icon: String, color: UIColor, searchId: SYPoiGroup) {
        self.name = name
        self.icon = icon
        self.color = color
        self.searchId = searchId
    }
    
    public class func with(syPoiGroup: SYPoiGroup) -> SYMKPoiGroup {
        switch syPoiGroup {
        case .unknown: return SYMKPoiGroup(name: "", icon: SYUIIcon.contextMenuIos, color: .poiGroupGuides, searchId: .unknown)
        case .food_and_Drink: return SYMKPoiGroup(name: LS("_grp.Food_and_Drink"), icon: SYUIIcon.food, color: .poiGroupFoodDrink, searchId: .food_and_Drink)
        case .accommodation: return SYMKPoiGroup(name: LS("_grp.Accomodation"), icon: SYUIIcon.accomodation, color: .poiGroupAccomodation, searchId: .accommodation)
        case .shopping: return SYMKPoiGroup(name: LS("_grp.Shopping"), icon: SYUIIcon.shopping, color: .poiGroupShopping, searchId: .shopping)
        case .transportation: return SYMKPoiGroup(name: LS("_grp.Transportation"), icon: SYUIIcon.plane, color: .poiGroupTransportation, searchId: .transportation)
        case .tourism: return SYMKPoiGroup(name: LS("_grp.Tourism"), icon: SYUIIcon.attraction, color: .poiGroupTourism, searchId: .tourism)
        case .social_Life: return SYMKPoiGroup(name: LS("_grp.Social_Life"), icon: SYUIIcon.theater, color: .poiGroupSocialLife, searchId: .social_Life)
        case .services_and_Education: return SYMKPoiGroup(name: LS("_grp.Services_and_Education"), icon: SYUIIcon.school, color: .poiGroupSvcEducation, searchId: .services_and_Education)
        case .sport: return SYMKPoiGroup(name: LS("_grp.Sport"), icon: SYUIIcon.running, color: .poiGroupSport, searchId: .sport)
        case .vehicle_Services: return SYMKPoiGroup(name: LS("_grp.Vehicle_Services"), icon: SYUIIcon.vehicle, color: .poiGroupVehicleServices, searchId: .vehicle_Services)
        case .emergency: return SYMKPoiGroup(name: LS("_grp.Emergency"), icon: SYUIIcon.hospital, color: .poiGroupEmergency, searchId: .emergency)
        case .guides: return SYMKPoiGroup(name: LS("_grp.Guides"), icon: SYUIIcon.infoCenter, color: .poiGroupGuides, searchId: .guides)
        case .parking: return SYMKPoiGroup(name: LS("_grp.Parking"), icon: SYUIIcon.parking, color: .poiGroupParking, searchId: .parking)
        case .petrol_Station: return SYMKPoiGroup(name: LS("_grp.Petrol_Station"), icon: SYUIIcon.stationPetrol, color: .poiGroupPetrolStation, searchId: .petrol_Station)
        case .bankATM: return SYMKPoiGroup(name: LS("_grp.BankATM"), icon: SYUIIcon.money, color: .poiGroupBank, searchId: .bankATM)
        }
    }
}
