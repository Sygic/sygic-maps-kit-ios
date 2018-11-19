import Foundation
import SygicUIKit
import SygicMaps

public class SYMKPoiCategory: NSObject, NSCoding {

    public let icon: String
    public let color: UIColor
    
    public init(icon: String, color: UIColor?) {
        self.icon = icon
        self.color = color ?? .textBody
        super.init()
    }
    
    public required convenience init?(coder decoder: NSCoder) {
        guard let icon = decoder.decodeObject(forKey: "icon") as? String,
            let color = decoder.decodeObject(forKey: "color") as? UIColor
            else { return nil }
        
        self.init(icon: icon, color: color)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(color, forKey: "color")
    }
    
    public class func with(syPoiCategory: SYPoiCategory) -> SYMKPoiCategory {
        switch syPoiCategory {
        case .unknown: return SYMKPoiCategory(icon: SygicIcon.pinPlace, color: .textBody)
            
        //Tourism
        case .tourist_Information_Office: return SYMKPoiCategory(icon: SygicIcon.infoCenter, color: .poiGroupTourism)
        case .museum: return SYMKPoiCategory(icon: SygicIcon.museum, color: .poiGroupTourism)
        case .zoo: return SYMKPoiCategory(icon: SygicIcon.zoo, color: .poiGroupTourism)
        case .scenic_Panoramic_View: return SYMKPoiCategory(icon: SygicIcon.mountines, color: .poiGroupTourism)
        case .camping_Ground: return SYMKPoiCategory(icon: SygicIcon.camp, color: .poiGroupTourism)
        case .caravan_Site: return SYMKPoiCategory(icon: SygicIcon.caravan, color: .poiGroupTourism)
        case .recreation_Facility: return SYMKPoiCategory(icon: SygicIcon.spa, color: .poiGroupTourism)
        case .beach: return SYMKPoiCategory(icon: SygicIcon.beach, color: .poiGroupTourism)
        case .mountain_Peak: return SYMKPoiCategory(icon: SygicIcon.peak, color: .poiGroupTourism)
        case .castle: return SYMKPoiCategory(icon: SygicIcon.chateau, color: .poiGroupTourism)
        case .fortress: return SYMKPoiCategory(icon: SygicIcon.stronghold, color: .poiGroupTourism)
        case .holiday_Area: return SYMKPoiCategory(icon: SygicIcon.beach, color: .poiGroupTourism)
        case .monument: return SYMKPoiCategory(icon: SygicIcon.monument, color: .poiGroupTourism)
        case .natural_Reserve: return SYMKPoiCategory(icon: SygicIcon.forest, color: .poiGroupTourism)
        case .mountain_Pass: return SYMKPoiCategory(icon: SygicIcon.peak, color: .poiGroupTourism)
        case .park_and_Recreation_Area: return SYMKPoiCategory(icon: SygicIcon.park, color: .poiGroupTourism)
        case .forest_Area: return SYMKPoiCategory(icon: SygicIcon.forest, color: .poiGroupTourism)
        case .natives_Reservation, .building_Footprint, .travel_Agency, .lighthouse, .rocks, .walking_Area, .water_Mill, .windmill, .archeology, .important_Tourist_Attraction:
            return SYMKPoiCategory(icon: SygicIcon.attraction, color: .poiGroupTourism)
            
        //Food and Drink
        case .winery: return SYMKPoiCategory(icon: SygicIcon.wine, color: .poiGroupFoodDrink)
        case .road_Side_Diner: return SYMKPoiCategory(icon: SygicIcon.food, color: .poiGroupFoodDrink)
        case .restaurant_Area: return SYMKPoiCategory(icon: SygicIcon.restaurant, color: .poiGroupFoodDrink)
        case .cafe_Pub: return SYMKPoiCategory(icon: SygicIcon.cafe, color: .poiGroupFoodDrink)
        case .pastry_and_Sweets: return SYMKPoiCategory(icon: SygicIcon.patisserie, color: .poiGroupFoodDrink)
        case .restaurant: return SYMKPoiCategory(icon: SygicIcon.restaurant, color: .poiGroupFoodDrink)
        case .food: return SYMKPoiCategory(icon: SygicIcon.food, color: .poiGroupFoodDrink)
            
        //Accomodation
        case .hotel_or_Motel: return SYMKPoiCategory(icon: SygicIcon.accomodation, color: .poiGroupAccomodation)
            
        //Parking
        case .rent_a_Car_Parking: return SYMKPoiCategory(icon: SygicIcon.carRental, color: .poiGroupParking)
        case .parking_Garage: return SYMKPoiCategory(icon: SygicIcon.parkingHouse, color: .poiGroupParking)
        case .coach_and_Lorry_Parking, .open_Parking_Area:
            return SYMKPoiCategory(icon: SygicIcon.parking, color: .poiGroupParking)
            
        //Petrol station
        case .petrol_Station: return SYMKPoiCategory(icon: SygicIcon.stationPetrol, color: .poiGroupPetrolStation)
            
        //Transportation
        case .ski_Lift_Station: return SYMKPoiCategory(icon: SygicIcon.cableway, color: .poiGroupTransportation)
        case .car_Shipping_Terminal: return SYMKPoiCategory(icon: SygicIcon.carCarrier, color: .poiGroupTransportation)
        case .airport: return SYMKPoiCategory(icon: SygicIcon.plane, color: .poiGroupTransportation)
        case .bus_Station: return SYMKPoiCategory(icon: SygicIcon.bus, color: .poiGroupTransportation)
        case .port: return SYMKPoiCategory(icon: SygicIcon.harbor, color: .poiGroupTransportation)
        case .ferry_Terminal: return SYMKPoiCategory(icon: SygicIcon.boat, color: .poiGroupTransportation)
        case .airline_Access: return SYMKPoiCategory(icon: SygicIcon.terminal, color: .poiGroupTransportation)
        case .railway_Station: return SYMKPoiCategory(icon: SygicIcon.train, color: .poiGroupTransportation)
        case .public_Transport_Stop: return SYMKPoiCategory(icon: SygicIcon.publicTransportStop, color: .poiGroupTransportation)
        case .metro: return SYMKPoiCategory(icon: SygicIcon.subway, color: .poiGroupTransportation)
            
        //Bank
        case .bank: return SYMKPoiCategory(icon: SygicIcon.bank, color: .poiGroupBank)
        case .ATM: return SYMKPoiCategory(icon: SygicIcon.ATM, color: .poiGroupBank)
            
        //Shopping
        case .department_Store: return SYMKPoiCategory(icon: SygicIcon.supermarket, color: .poiGroupShopping)
        case .warehouse: return SYMKPoiCategory(icon: SygicIcon.warehouse, color: .poiGroupShopping)
        case .groceries: return SYMKPoiCategory(icon: SygicIcon.groceryStore, color: .poiGroupShopping)
        case .supermarket: return SYMKPoiCategory(icon: SygicIcon.supermarket, color: .poiGroupShopping)
        case .accessories_Furniture: return SYMKPoiCategory(icon: SygicIcon.furniture, color: .poiGroupShopping)
        case .books_Cards: return SYMKPoiCategory(icon: SygicIcon.bookShop, color: .poiGroupShopping)
        case .children_Toys: return SYMKPoiCategory(icon: SygicIcon.toyStore, color: .poiGroupShopping)
        case .cosmetics_Perfumes: return SYMKPoiCategory(icon: SygicIcon.parfumes, color: .poiGroupShopping)
        case .gifts_Antiques: return SYMKPoiCategory(icon: SygicIcon.presents, color: .poiGroupShopping)
        case .jewellery_Watches: return SYMKPoiCategory(icon: SygicIcon.jewelery, color: .poiGroupShopping)
        case .lifestyle_Fitness: return SYMKPoiCategory(icon: SygicIcon.fitness, color: .poiGroupShopping)
        case .shoes_Bags: return SYMKPoiCategory(icon: SygicIcon.shoeStore, color: .poiGroupShopping)
        case .sports: return SYMKPoiCategory(icon: SygicIcon.running, color: .poiGroupShopping)
            
        case .childrens_Fashion, .fashion_Mixed, .fashion_Accessories, .traditional_Fashion, .ladies_Fashion, .men_s_Fashion:
            return SYMKPoiCategory(icon: SygicIcon.fashion, color: .poiGroupShopping)
            
        case .mobile_Shop, .electronics_Mobiles:
            return SYMKPoiCategory(icon: SygicIcon.deviceIphone, color: .poiGroupShopping)
            
        case .shopping_Centre, .hair_And_Beauty, .shop, .opticians_Sunglasses:
            return SYMKPoiCategory(icon: SygicIcon.shopping, color: .poiGroupShopping)
            
        //Vehicle services
        case .trafficLights: return SYMKPoiCategory(icon: SygicIcon.trafficLights, color: .poiGroupVehicleServices)
        case .rent_a_Car_Facility: return SYMKPoiCategory(icon: SygicIcon.carRental, color: .poiGroupVehicleServices)
        case .bovag_Garage: return SYMKPoiCategory(icon: SygicIcon.parkingHouse, color: .poiGroupVehicleServices)
        case .rest_Area: return SYMKPoiCategory(icon: SygicIcon.restingArea, color: .poiGroupVehicleServices)
        case .park_And_Ride: return SYMKPoiCategory(icon: SygicIcon.parking, color: .poiGroupVehicleServices)
        case .speed_Cameras: return SYMKPoiCategory(icon: SygicIcon.speedcam, color: .poiGroupVehicleServices)
            
        case .vehicle_Equipment_Provider, .car_Repair_Facility, .chevrolet_Car_Repair:
            return SYMKPoiCategory(icon: SygicIcon.serviceStation, color: .poiGroupVehicleServices)
            
        case .motoring_Organization_Office, .car_Dealer, .car_Services, .chevrolet_Car_Dealer:
            return SYMKPoiCategory(icon: SygicIcon.vehicle, color: .poiGroupVehicleServices)
            
        //Social life
        case .casino: return SYMKPoiCategory(icon: SygicIcon.casino, color: .poiGroupSocialLife)
        case .cinema: return SYMKPoiCategory(icon: SygicIcon.cinema, color: .poiGroupSocialLife)
        case .opera: return SYMKPoiCategory(icon: SygicIcon.opera, color: .poiGroupSocialLife)
        case .leisure_Centre: return SYMKPoiCategory(icon: SygicIcon.spa, color: .poiGroupSocialLife)
        case .nightlife: return SYMKPoiCategory(icon: SygicIcon.bar, color: .poiGroupSocialLife)
        case .general: return SYMKPoiCategory(icon: SygicIcon.pinPlace, color: .poiGroupSocialLife)
        case .amusement_Park: return SYMKPoiCategory(icon: SygicIcon.amusementPark, color: .poiGroupSocialLife)
        case .arts_Centre: return SYMKPoiCategory(icon: SygicIcon.gallery, color: .poiGroupSocialLife)
        case .library: return SYMKPoiCategory(icon: SygicIcon.library, color: .poiGroupSocialLife)
        case .ecotourism_Sites: return SYMKPoiCategory(icon: SygicIcon.forest, color: .poiGroupSocialLife)
        case .hunting_Shop: return SYMKPoiCategory(icon: SygicIcon.supermarket, color: .poiGroupSocialLife)
        case .kids_Place: return SYMKPoiCategory(icon: SygicIcon.playGround, color: .poiGroupSocialLife)
        case .mosque: return SYMKPoiCategory(icon: SygicIcon.mosque, color: .poiGroupSocialLife)
        case .place_of_Worship: return SYMKPoiCategory(icon: SygicIcon.pray, color: .poiGroupSocialLife)
            
        case .abbey, .church, .monastery:
            return SYMKPoiCategory(icon: SygicIcon.church, color: .poiGroupSocialLife)
            
        case .concert_Hall, .music_Centre:
            return SYMKPoiCategory(icon: SygicIcon.philharmonic, color: .poiGroupSocialLife)
            
        case .theatre, .cultural_Centre, .entertainment:
            return SYMKPoiCategory(icon: SygicIcon.theater, color: .poiGroupSocialLife)
            
        //Services and education
        case .post_Office: return SYMKPoiCategory(icon: SygicIcon.postOffice, color: .poiGroupSvcEducation)
        case .public_Phone: return SYMKPoiCategory(icon: SygicIcon.call, color: .poiGroupSvcEducation)
        case .transport_Company: return SYMKPoiCategory(icon: SygicIcon.truck, color: .poiGroupSvcEducation)
        case .cargo_Centre: return SYMKPoiCategory(icon: SygicIcon.warehouse, color: .poiGroupSvcEducation)
        case .school: return SYMKPoiCategory(icon: SygicIcon.schoolZone, color: .poiGroupSvcEducation)
        case .toll: return SYMKPoiCategory(icon: SygicIcon.avoidTollRoads, color: .poiGroupSvcEducation)
        case .college_University: return SYMKPoiCategory(icon: SygicIcon.school, color: .poiGroupSvcEducation)
        case .kindergarten: return SYMKPoiCategory(icon: SygicIcon.kindergarten, color: .poiGroupSvcEducation)
        case .courthouse: return SYMKPoiCategory(icon: SygicIcon.court, color: .poiGroupSvcEducation)
        case .convention_Centre: return SYMKPoiCategory(icon: SygicIcon.conferenceHall, color: .poiGroupSvcEducation)
        case .prison: return SYMKPoiCategory(icon: SygicIcon.jail, color: .poiGroupSvcEducation)
        case .state_Police_Office: return SYMKPoiCategory(icon: SygicIcon.police, color: .poiGroupSvcEducation)
        case .agricultural_Industry: return SYMKPoiCategory(icon: SygicIcon.farm, color: .poiGroupSvcEducation)
        case .medical_Material: return SYMKPoiCategory(icon: SygicIcon.drugStore, color: .poiGroupSvcEducation)
        case .personal_Services: return SYMKPoiCategory(icon: SygicIcon.profile, color: .poiGroupSvcEducation)
        case .military_Installation: return SYMKPoiCategory(icon: SygicIcon.army, color: .poiGroupSvcEducation)
        case .cash_Dispenser: return SYMKPoiCategory(icon: SygicIcon.money, color: .poiGroupSvcEducation)
            
        case .exchange, .money_Transfer:
            return SYMKPoiCategory(icon: SygicIcon.moneyExchange, color: .poiGroupSvcEducation)
            
        case .cemetery, .military_Cemetery:
            return SYMKPoiCategory(icon: SygicIcon.cemetery, color: .poiGroupSvcEducation)
            
        case .industrial_Building, .factories, .factory_Ground_Philips:
            return SYMKPoiCategory(icon: SygicIcon.factory, color: .poiGroupSvcEducation)
            
        case .condominium, .commercial_Building, .real_Estate:
            return SYMKPoiCategory(icon: SygicIcon.city, color: .poiGroupSvcEducation)
            
        case .freeport, .company, .construction, .media, .professionals, .services, .squares, .local_Names:
            return SYMKPoiCategory(icon: SygicIcon.pinPlace, color: .poiGroupSvcEducation)
            
        case .customs, .frontier_Crossing, .border_Point:
            return SYMKPoiCategory(icon: SygicIcon.borderCrossing, color: .poiGroupSvcEducation)
            
        case .community_Centre, .business_Facility, .exhibition_Centre, .government_Office:
            return SYMKPoiCategory(icon: SygicIcon.office, color: .poiGroupSvcEducation)
            
        case .city_Hall, .embassy:
            return SYMKPoiCategory(icon: SygicIcon.church, color: .poiGroupSvcEducation)
            
        //Sport
        case .tennis_Court: return SYMKPoiCategory(icon: SygicIcon.tennis, color: .poiGroupSport)
        case .yacht_Basin: return SYMKPoiCategory(icon: SygicIcon.harbor, color: .poiGroupSport)
        case .golf_Course: return SYMKPoiCategory(icon: SygicIcon.golf, color: .poiGroupSport)
            
        case .ice_Skating_Rink, .skating_Rink:
            return SYMKPoiCategory(icon: SygicIcon.running, color: .poiGroupSport)
            
        case .water_Sport, .swimming_Pool:
            return SYMKPoiCategory(icon: SygicIcon.swimming, color: .poiGroupSport)
            
        case .sports_Centre, .stadium, .hippodrome, .sports_Hall, .car_Racetrack:
            return SYMKPoiCategory(icon: SygicIcon.stadium, color: .poiGroupSport)
            
        //Guides
        case .wikipedia: return SYMKPoiCategory(icon: SygicIcon.infoCenter, color: .poiGroupGuides)
            
        //Emergency
        case .police_Station: return SYMKPoiCategory(icon: SygicIcon.police, color: .poiGroupEmergency)
        case .pharmacy: return SYMKPoiCategory(icon: SygicIcon.drugStore, color: .poiGroupEmergency)
        case .emergency_Call_Station: return SYMKPoiCategory(icon: SygicIcon.emergencyPhone, color: .poiGroupEmergency)
        case .fire_Brigade: return SYMKPoiCategory(icon: SygicIcon.firefighters, color: .poiGroupEmergency)
        case .dentist: return SYMKPoiCategory(icon: SygicIcon.dentist, color: .poiGroupEmergency)
        case .veterinarian: return SYMKPoiCategory(icon: SygicIcon.vet, color: .poiGroupEmergency)
        case .breakdown_Service: return SYMKPoiCategory(icon: SygicIcon.serviceStation, color: .poiGroupEmergency)
            
        case .first_Aid_Post, .emergency_Medical_Service:
            return SYMKPoiCategory(icon: SygicIcon.ambulance, color: .poiGroupEmergency)
        case .hospital_Polyclinic, .doctor:
            return SYMKPoiCategory(icon: SygicIcon.hospital, color: .poiGroupEmergency)
        }
    }
}
