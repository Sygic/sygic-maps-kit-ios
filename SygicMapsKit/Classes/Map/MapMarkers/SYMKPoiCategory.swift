//// SYMKPlaceCategory.swift
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
public class SYMKPlaceCategory {

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
    /// - Returns: `SYMKPlaceCategory` object with specific icon and color for a `SYPoiCategory`.
    public class func with(sdkPlaceCategory: String) -> SYMKPlaceCategory {
        //Tourism
        if sdkPlaceCategory == SYPlaceCategoryTouristInformationOffice  { return SYMKPlaceCategory(icon: SYUIIcon.infoCenter, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryMuseum                    { return SYMKPlaceCategory(icon: SYUIIcon.museum, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryZoo                       { return SYMKPlaceCategory(icon: SYUIIcon.zoo, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryScenicPanoramicView       { return SYMKPlaceCategory(icon: SYUIIcon.mountines, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryCampingGround             { return SYMKPlaceCategory(icon: SYUIIcon.camp, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryCaravanSite               { return SYMKPlaceCategory(icon: SYUIIcon.caravan, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryRecreationFacility        { return SYMKPlaceCategory(icon: SYUIIcon.spa, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryBeach                     { return SYMKPlaceCategory(icon: SYUIIcon.beach, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryMountainPeak              { return SYMKPlaceCategory(icon: SYUIIcon.peak, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryCastle                    { return SYMKPlaceCategory(icon: SYUIIcon.chateau, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryFortressv                 { return SYMKPlaceCategory(icon: SYUIIcon.stronghold, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryHolidayArea               { return SYMKPlaceCategory(icon: SYUIIcon.beach, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryMonument                  { return SYMKPlaceCategory(icon: SYUIIcon.monument, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryNaturalReserve            { return SYMKPlaceCategory(icon: SYUIIcon.forest, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryMountainPass              { return SYMKPlaceCategory(icon: SYUIIcon.peak, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryParkAndRecreationArea     { return SYMKPlaceCategory(icon: SYUIIcon.park, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryForestArea                { return SYMKPlaceCategory(icon: SYUIIcon.forest, color: .poiGroupTourism) }
        if sdkPlaceCategory == SYPlaceCategoryNativesReservation ||
            sdkPlaceCategory == SYPlaceCategoryBuildingFootprint ||
            sdkPlaceCategory == SYPlaceCategoryTravelAgency ||
            sdkPlaceCategory == SYPlaceCategoryLighthouse ||
            sdkPlaceCategory == SYPlaceCategoryRocks ||
            sdkPlaceCategory == SYPlaceCategoryWalkingArea ||
            sdkPlaceCategory == SYPlaceCategoryWaterMill ||
            sdkPlaceCategory == SYPlaceCategoryWindmill ||
            sdkPlaceCategory == SYPlaceCategoryArcheology ||
            sdkPlaceCategory == SYPlaceCategoryImportantTouristAttraction { return SYMKPlaceCategory(icon: SYUIIcon.attraction, color: .poiGroupTourism) }
        
        //Food and Drink
        if sdkPlaceCategory == SYPlaceCategoryWinery            { return SYMKPlaceCategory(icon: SYUIIcon.wine, color: .poiGroupFoodDrink) }
        if sdkPlaceCategory == SYPlaceCategoryRoadSideDiner     { return SYMKPlaceCategory(icon: SYUIIcon.food, color: .poiGroupFoodDrink) }
        if sdkPlaceCategory == SYPlaceCategoryRestaurantArea    { return SYMKPlaceCategory(icon: SYUIIcon.restaurant, color: .poiGroupFoodDrink) }
        if sdkPlaceCategory == SYPlaceCategoryCafePub           { return SYMKPlaceCategory(icon: SYUIIcon.cafe, color: .poiGroupFoodDrink) }
        if sdkPlaceCategory == SYPlaceCategoryPastryAndSweets   { return SYMKPlaceCategory(icon: SYUIIcon.patisserie, color: .poiGroupFoodDrink) }
        if sdkPlaceCategory == SYPlaceCategoryRestaurant        { return SYMKPlaceCategory(icon: SYUIIcon.restaurant, color: .poiGroupFoodDrink) }
        if sdkPlaceCategory == SYPlaceCategoryFood              { return SYMKPlaceCategory(icon: SYUIIcon.food, color: .poiGroupFoodDrink) }

        //Accomodation
        if sdkPlaceCategory == SYPlaceCategoryHotelOrMotel  { return SYMKPlaceCategory(icon: SYUIIcon.accomodation, color: .poiGroupAccomodation) }

        //Parking
        if sdkPlaceCategory == SYPlaceCategoryRentACarParking   { return SYMKPlaceCategory(icon: SYUIIcon.carRental, color: .poiGroupParking) }
        if sdkPlaceCategory == SYPlaceCategoryParkingGarage     { return SYMKPlaceCategory(icon: SYUIIcon.parkingHouse, color: .poiGroupParking) }
        if sdkPlaceCategory == SYPlaceCategoryCoachAndLorryParking ||
            sdkPlaceCategory == SYPlaceCategoryOpenParkingArea  { return SYMKPlaceCategory(icon: SYUIIcon.parking, color: .poiGroupParking) }

        //Petrol station
        if sdkPlaceCategory == SYPlaceCategoryPetrolStation     { return SYMKPlaceCategory(icon: SYUIIcon.stationPetrol, color: .poiGroupPetrolStation) }

        //Transportation
        if sdkPlaceCategory == SYPlaceCategorySkiLiftStation        { return SYMKPlaceCategory(icon: SYUIIcon.cableway, color: .poiGroupTransportation) }
        if sdkPlaceCategory == SYPlaceCategoryCarShippingTerminal   { return SYMKPlaceCategory(icon: SYUIIcon.carCarrier, color: .poiGroupTransportation) }
        if sdkPlaceCategory == SYPlaceCategoryAirport               { return SYMKPlaceCategory(icon: SYUIIcon.plane, color: .poiGroupTransportation) }
        if sdkPlaceCategory == SYPlaceCategoryBusStation            { return SYMKPlaceCategory(icon: SYUIIcon.bus, color: .poiGroupTransportation) }
        if sdkPlaceCategory == SYPlaceCategoryPort                  { return SYMKPlaceCategory(icon: SYUIIcon.harbor, color: .poiGroupTransportation) }
        if sdkPlaceCategory == SYPlaceCategoryFerryTerminal         { return SYMKPlaceCategory(icon: SYUIIcon.boat, color: .poiGroupTransportation) }
        if sdkPlaceCategory == SYPlaceCategoryAirlineAccess         { return SYMKPlaceCategory(icon: SYUIIcon.terminal, color: .poiGroupTransportation) }
        if sdkPlaceCategory == SYPlaceCategoryRailwayStation        { return SYMKPlaceCategory(icon: SYUIIcon.train, color: .poiGroupTransportation) }
        if sdkPlaceCategory == SYPlaceCategoryPublicTransportStop   { return SYMKPlaceCategory(icon: SYUIIcon.publicTransportStop, color: .poiGroupTransportation) }
        if sdkPlaceCategory == SYPlaceCategoryMetro                 { return SYMKPlaceCategory(icon: SYUIIcon.subway, color: .poiGroupTransportation) }

        //Bank
        if sdkPlaceCategory == SYPlaceCategoryBank          { return SYMKPlaceCategory(icon: SYUIIcon.bank, color: .poiGroupBank) }
        if sdkPlaceCategory == SYPlaceCategoryATM           { return SYMKPlaceCategory(icon: SYUIIcon.ATM, color: .poiGroupBank) }

        //Shopping
        if sdkPlaceCategory == SYPlaceCategoryDepartmentStore       { return SYMKPlaceCategory(icon: SYUIIcon.supermarket, color: .poiGroupShopping) }
        if sdkPlaceCategory == SYPlaceCategoryWarehouse             { return SYMKPlaceCategory(icon: SYUIIcon.warehouse, color: .poiGroupShopping) }
        if sdkPlaceCategory == SYPlaceCategoryGroceries             { return SYMKPlaceCategory(icon: SYUIIcon.groceryStore, color: .poiGroupShopping) }
        if sdkPlaceCategory == SYPlaceCategorySupermarket           { return SYMKPlaceCategory(icon: SYUIIcon.supermarket, color: .poiGroupShopping) }
        if sdkPlaceCategory == SYPlaceCategoryAccessoriesFurniture  { return SYMKPlaceCategory(icon: SYUIIcon.furniture, color: .poiGroupShopping) }
        if sdkPlaceCategory == SYPlaceCategoryBooksCards            { return SYMKPlaceCategory(icon: SYUIIcon.bookShop, color: .poiGroupShopping) }
        if sdkPlaceCategory == SYPlaceCategoryChildrenToys          { return SYMKPlaceCategory(icon: SYUIIcon.toyStore, color: .poiGroupShopping) }
        if sdkPlaceCategory == SYPlaceCategoryCosmeticsPerfumes     { return SYMKPlaceCategory(icon: SYUIIcon.parfumes, color: .poiGroupShopping) }
        if sdkPlaceCategory == SYPlaceCategoryGiftsAntiques         { return SYMKPlaceCategory(icon: SYUIIcon.presents, color: .poiGroupShopping) }
        if sdkPlaceCategory == SYPlaceCategoryJewelleryWatches      { return SYMKPlaceCategory(icon: SYUIIcon.jewelery, color: .poiGroupShopping) }
        if sdkPlaceCategory == SYPlaceCategoryLifestyleFitness      { return SYMKPlaceCategory(icon: SYUIIcon.fitness, color: .poiGroupShopping) }
        if sdkPlaceCategory == SYPlaceCategoryShoesBags             { return SYMKPlaceCategory(icon: SYUIIcon.shoeStore, color: .poiGroupShopping) }
        if sdkPlaceCategory == SYPlaceCategorySports                { return SYMKPlaceCategory(icon: SYUIIcon.running, color: .poiGroupShopping) }
        if sdkPlaceCategory == SYPlaceCategoryChildrensFashion ||
            sdkPlaceCategory == SYPlaceCategoryFashionMixed ||
            sdkPlaceCategory == SYPlaceCategoryFashionAccessories ||
            sdkPlaceCategory == SYPlaceCategoryTraditionalFashion ||
            sdkPlaceCategory == SYPlaceCategoryLadiesFashion ||
            sdkPlaceCategory == SYPlaceCategoryMenSFashion          { return SYMKPlaceCategory(icon: SYUIIcon.fashion, color: .poiGroupShopping) }
        if sdkPlaceCategory == SYPlaceCategoryMobileShop ||
            sdkPlaceCategory == SYPlaceCategoryElectronicsMobiles   { return SYMKPlaceCategory(icon: SYUIIcon.deviceIphone, color: .poiGroupShopping) }
        if sdkPlaceCategory == SYPlaceCategoryShoppingCentre ||
            sdkPlaceCategory == SYPlaceCategoryHairAndBeauty ||
            sdkPlaceCategory == SYPlaceCategoryShop ||
            sdkPlaceCategory == SYPlaceCategoryOpticiansSunglasses  { return SYMKPlaceCategory(icon: SYUIIcon.shopping, color: .poiGroupShopping) }
        
        //Vehicle services
        if sdkPlaceCategory == SYPlaceCategoryTrafficLights     { return SYMKPlaceCategory(icon: SYUIIcon.trafficLights, color: .poiGroupVehicleServices) }
        if sdkPlaceCategory == SYPlaceCategoryRentACarFacility  { return SYMKPlaceCategory(icon: SYUIIcon.carRental, color: .poiGroupVehicleServices) }
        if sdkPlaceCategory == SYPlaceCategoryBovagGarage       { return SYMKPlaceCategory(icon: SYUIIcon.parkingHouse, color: .poiGroupVehicleServices) }
        if sdkPlaceCategory == SYPlaceCategoryRestArea          { return SYMKPlaceCategory(icon: SYUIIcon.restingArea, color: .poiGroupVehicleServices) }
        if sdkPlaceCategory == SYPlaceCategoryParkAndRide       { return SYMKPlaceCategory(icon: SYUIIcon.parking, color: .poiGroupVehicleServices) }
        if sdkPlaceCategory == SYPlaceCategorySpeedCameras      { return SYMKPlaceCategory(icon: SYUIIcon.speedcam, color: .poiGroupVehicleServices) }
        if sdkPlaceCategory == SYPlaceCategoryVehicleEquipmentProvider ||
            sdkPlaceCategory == SYPlaceCategoryCarRepairFacility ||
            sdkPlaceCategory == SYPlaceCategoryChevroletCarRepair { return SYMKPlaceCategory(icon: SYUIIcon.serviceStation, color: .poiGroupVehicleServices) }
        if sdkPlaceCategory == SYPlaceCategoryMotoringOrganizationOffice ||
            sdkPlaceCategory == SYPlaceCategoryCarDealer ||
            sdkPlaceCategory == SYPlaceCategoryCarServices ||
            sdkPlaceCategory == SYPlaceCategoryChevroletCarDealer { return SYMKPlaceCategory(icon: SYUIIcon.vehicle, color: .poiGroupVehicleServices) }

        //Social life
        if sdkPlaceCategory == SYPlaceCategoryCasino            { return SYMKPlaceCategory(icon: SYUIIcon.casino, color: .poiGroupSocialLife) }
        if sdkPlaceCategory == SYPlaceCategoryCinema            { return SYMKPlaceCategory(icon: SYUIIcon.cinema, color: .poiGroupSocialLife) }
        if sdkPlaceCategory == SYPlaceCategoryOpera             { return SYMKPlaceCategory(icon: SYUIIcon.opera, color: .poiGroupSocialLife) }
        if sdkPlaceCategory == SYPlaceCategoryLeisureCentre     { return SYMKPlaceCategory(icon: SYUIIcon.spa, color: .poiGroupSocialLife) }
        if sdkPlaceCategory == SYPlaceCategoryNightlife         { return SYMKPlaceCategory(icon: SYUIIcon.bar, color: .poiGroupSocialLife) }
        if sdkPlaceCategory == SYPlaceCategoryGeneral           { return SYMKPlaceCategory(icon: SYUIIcon.pinPlace, color: .poiGroupSocialLife) }
        if sdkPlaceCategory == SYPlaceCategoryAmusementPark     { return SYMKPlaceCategory(icon: SYUIIcon.amusementPark, color: .poiGroupSocialLife) }
        if sdkPlaceCategory == SYPlaceCategoryArtsCentre        { return SYMKPlaceCategory(icon: SYUIIcon.gallery, color: .poiGroupSocialLife) }
        if sdkPlaceCategory == SYPlaceCategoryLibrary           { return SYMKPlaceCategory(icon: SYUIIcon.library, color: .poiGroupSocialLife) }
        if sdkPlaceCategory == SYPlaceCategoryEcotourismSites   { return SYMKPlaceCategory(icon: SYUIIcon.forest, color: .poiGroupSocialLife) }
        if sdkPlaceCategory == SYPlaceCategoryHuntingShop       { return SYMKPlaceCategory(icon: SYUIIcon.supermarket, color: .poiGroupSocialLife) }
        if sdkPlaceCategory == SYPlaceCategoryKidsPlace         { return SYMKPlaceCategory(icon: SYUIIcon.playGround, color: .poiGroupSocialLife) }
        if sdkPlaceCategory == SYPlaceCategoryMosque            { return SYMKPlaceCategory(icon: SYUIIcon.mosque, color: .poiGroupSocialLife) }
        if sdkPlaceCategory == SYPlaceCategoryPlaceOfWorship    { return SYMKPlaceCategory(icon: SYUIIcon.pray, color: .poiGroupSocialLife) }
        if sdkPlaceCategory == SYPlaceCategoryAbbey ||
            sdkPlaceCategory == SYPlaceCategoryChurch ||
            sdkPlaceCategory == SYPlaceCategoryMonastery        { return SYMKPlaceCategory(icon: SYUIIcon.church, color: .poiGroupSocialLife) }
        if sdkPlaceCategory == SYPlaceCategoryConcertHall ||
            sdkPlaceCategory == SYPlaceCategoryMusicCentre      { return SYMKPlaceCategory(icon: SYUIIcon.philharmonic, color: .poiGroupSocialLife) }
        if sdkPlaceCategory == SYPlaceCategoryTheatre ||
            sdkPlaceCategory == SYPlaceCategoryCulturalCentre ||
            sdkPlaceCategory == SYPlaceCategoryEntertainment    { return SYMKPlaceCategory(icon: SYUIIcon.theater, color: .poiGroupSocialLife) }

        //Services and education
        if sdkPlaceCategory == SYPlaceCategoryPostOffice        { return SYMKPlaceCategory(icon: SYUIIcon.postOffice, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryPublicPhone       { return SYMKPlaceCategory(icon: SYUIIcon.call, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryTransportCompany  { return SYMKPlaceCategory(icon: SYUIIcon.truck, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryCargoCentre       { return SYMKPlaceCategory(icon: SYUIIcon.warehouse, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategorySchool            { return SYMKPlaceCategory(icon: SYUIIcon.schoolZone, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryToll              { return SYMKPlaceCategory(icon: SYUIIcon.avoidTollRoads, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryCollegeUniversity { return SYMKPlaceCategory(icon: SYUIIcon.school, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryKindergarten      { return SYMKPlaceCategory(icon: SYUIIcon.kindergarten, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryCourthouse        { return SYMKPlaceCategory(icon: SYUIIcon.court, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryConventionCentre  { return SYMKPlaceCategory(icon: SYUIIcon.conferenceHall, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryPrison            { return SYMKPlaceCategory(icon: SYUIIcon.jail, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryStatePoliceOffice { return SYMKPlaceCategory(icon: SYUIIcon.police, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryAgriculturalIndustry  { return SYMKPlaceCategory(icon: SYUIIcon.farm, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryMedicalMaterial   { return SYMKPlaceCategory(icon: SYUIIcon.drugStore, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryPersonalServices  { return SYMKPlaceCategory(icon: SYUIIcon.profile, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryMilitaryInstallation { return SYMKPlaceCategory(icon: SYUIIcon.army, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryCashDispenser     { return SYMKPlaceCategory(icon: SYUIIcon.money, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryExchange ||
            sdkPlaceCategory == SYPlaceCategoryMoneyTransfer    { return SYMKPlaceCategory(icon: SYUIIcon.moneyExchange, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryCemetery ||
            sdkPlaceCategory == SYPlaceCategoryMilitaryCemetery { return SYMKPlaceCategory(icon: SYUIIcon.cemetery, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryIndustrialBuilding ||
            sdkPlaceCategory == SYPlaceCategoryFactories ||
            sdkPlaceCategory == SYPlaceCategoryFactoryGroundPhilips { return SYMKPlaceCategory(icon: SYUIIcon.factory, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryCondominium ||
            sdkPlaceCategory == SYPlaceCategoryCommercialBuilding ||
            sdkPlaceCategory == SYPlaceCategoryRealEstate       { return SYMKPlaceCategory(icon: SYUIIcon.city, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryFreeport ||
            sdkPlaceCategory == SYPlaceCategoryCompany ||
            sdkPlaceCategory == SYPlaceCategoryConstruction ||
            sdkPlaceCategory == SYPlaceCategoryMedia ||
            sdkPlaceCategory == SYPlaceCategoryProfessionals ||
            sdkPlaceCategory == SYPlaceCategoryServices ||
            sdkPlaceCategory == SYPlaceCategorySquares ||
            sdkPlaceCategory == SYPlaceCategoryLocalNames       { return SYMKPlaceCategory(icon: SYUIIcon.pinPlace, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryCustoms ||
            sdkPlaceCategory == SYPlaceCategoryFrontierCrossing ||
            sdkPlaceCategory == SYPlaceCategoryBorderPoint      { return SYMKPlaceCategory(icon: SYUIIcon.borderCrossing, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryCommunityCentre ||
            sdkPlaceCategory == SYPlaceCategoryBusinessFacility ||
            sdkPlaceCategory == SYPlaceCategoryExhibitionCentre ||
            sdkPlaceCategory == SYPlaceCategoryGovernmentOffice { return SYMKPlaceCategory(icon: SYUIIcon.office, color: .poiGroupSvcEducation) }
        if sdkPlaceCategory == SYPlaceCategoryCityHall ||
            sdkPlaceCategory == SYPlaceCategoryEmbassy          { return SYMKPlaceCategory(icon: SYUIIcon.church, color: .poiGroupSvcEducation) }

        //Sport
        if sdkPlaceCategory == SYPlaceCategoryTennisCourt   { return SYMKPlaceCategory(icon: SYUIIcon.tennis, color: .poiGroupSport) }
        if sdkPlaceCategory == SYPlaceCategoryYachtBasin    { return SYMKPlaceCategory(icon: SYUIIcon.harbor, color: .poiGroupSport) }
        if sdkPlaceCategory == SYPlaceCategoryGolfCourse    { return SYMKPlaceCategory(icon: SYUIIcon.golf, color: .poiGroupSport) }
        if sdkPlaceCategory == SYPlaceCategoryIceSkatingRink ||
            sdkPlaceCategory == SYPlaceCategorySkatingRink  { return SYMKPlaceCategory(icon: SYUIIcon.running, color: .poiGroupSport) }
        if sdkPlaceCategory == SYPlaceCategoryWaterSport ||
            sdkPlaceCategory == SYPlaceCategorySwimmingPool { return SYMKPlaceCategory(icon: SYUIIcon.swimming, color: .poiGroupSport) }
        if sdkPlaceCategory == SYPlaceCategorySportsCentre ||
            sdkPlaceCategory == SYPlaceCategoryHippodrome ||
            sdkPlaceCategory == SYPlaceCategorySportsHall ||
            sdkPlaceCategory == SYPlaceCategoryCarRacetrack ||
            sdkPlaceCategory == SYPlaceCategoryStadium { return SYMKPlaceCategory(icon: SYUIIcon.stadium, color: .poiGroupSport) }

        //Guides
        if sdkPlaceCategory == SYPlaceCategoryWikipedia { return SYMKPlaceCategory(icon: SYUIIcon.infoCenter, color: .poiGroupGuides) }

        //Emergency
        if sdkPlaceCategory == SYPlaceCategoryPoliceStation     { return SYMKPlaceCategory(icon: SYUIIcon.police, color: .poiGroupEmergency) }
        if sdkPlaceCategory == SYPlaceCategoryPharmacy          { return SYMKPlaceCategory(icon: SYUIIcon.drugStore, color: .poiGroupEmergency) }
        if sdkPlaceCategory == SYPlaceCategoryEmergencyCallStation { return SYMKPlaceCategory(icon: SYUIIcon.emergencyPhone, color: .poiGroupEmergency) }
        if sdkPlaceCategory == SYPlaceCategoryFireBrigade       { return SYMKPlaceCategory(icon: SYUIIcon.firefighters, color: .poiGroupEmergency) }
        if sdkPlaceCategory == SYPlaceCategoryDentist           { return SYMKPlaceCategory(icon: SYUIIcon.dentist, color: .poiGroupEmergency) }
        if sdkPlaceCategory == SYPlaceCategoryVeterinarian      { return SYMKPlaceCategory(icon: SYUIIcon.vet, color: .poiGroupEmergency) }
        if sdkPlaceCategory == SYPlaceCategoryBreakdownService  { return SYMKPlaceCategory(icon: SYUIIcon.serviceStation, color: .poiGroupEmergency) }
        if sdkPlaceCategory == SYPlaceCategoryFirstAidPost ||
            sdkPlaceCategory == SYPlaceCategoryEmergencyMedicalService { return SYMKPlaceCategory(icon: SYUIIcon.ambulance, color: .poiGroupEmergency) }
        if sdkPlaceCategory == SYPlaceCategoryHospitalPolyclinic ||
            sdkPlaceCategory == SYPlaceCategoryDoctor { return SYMKPlaceCategory(icon: SYUIIcon.hospital, color: .poiGroupEmergency) }
        
        //Unknown
        return SYMKPlaceCategory(icon: SYUIIcon.pinPlace, color: .textBody)
    }
    
}
