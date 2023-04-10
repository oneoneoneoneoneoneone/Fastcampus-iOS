//
//  MapView.swift
//  FindCoronaCenter
//
//  Created by hana on 2023/04/10.
//

import SwiftUI
import MapKit

//MapKit - apple 자체 지도라이브러리
//AnnotationItem - 핀표시(MapMarker)를 위한 데이터
struct AnnotationItem: Identifiable{
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}


struct MapView: View {
    var coordination: CLLocationCoordinate2D
    //@State - ObservedObject와 달리 뷰 내부에서 변화하는 상태, 외부의 영향을 받지 않음 - 호출시 $var
    @State private var region = MKCoordinateRegion()
    @State private var annotationItems = [AnnotationItem]()
        
    var body: some View {
        Map(coordinateRegion: $region,
            annotationItems: [AnnotationItem(coordinate: coordination)],
            annotationContent: {
                MapMarker(coordinate: $0.coordinate)
            }
        )
        //객체가 Appear할 때 동작 정의
        .onAppear{
            setRegion(coordination)
            setAnnotationItems(coordination)
        }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D){
        //span 확대 정도 - 0~1
        region = MKCoordinateRegion(center: coordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
    
    private func setAnnotationItems(_ coordinate: CLLocationCoordinate2D){
        annotationItems = [AnnotationItem(coordinate: coordinate)]
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let center0 = Center(id: 0, sido: .경기도, address: "경기도 어쩌고", lat: "37.123456", lng: "126.1234678", centerName: "시민체육관", centerType: .central, facilityName: "정문 앞", phoneNumber: "010-1234-6789")
        
        MapView(coordination: CLLocationCoordinate2D(latitude: CLLocationDegrees(center0.lat) ?? .zero, longitude: CLLocationDegrees(center0.lng) ?? .zero))
    }
}
