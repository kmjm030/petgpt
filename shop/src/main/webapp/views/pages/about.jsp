<%@ page pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <script type="text/javascript"
      src="//dapi.kakao.com/v2/maps/sdk.js?appkey=1d80cc061f948248f9465d96f87b1f5c&libraries=services"></script>
    <script>
      document.addEventListener("DOMContentLoaded", function () {

        var mapContainer = document.getElementById('map');
        if (!mapContainer) {
          console.error("Map container element with id 'map' not found.");
          return;
        }

        var mapOption = {
          center: new kakao.maps.LatLng(36.3504, 127.3845),
          level: 7
        };

        window.map = new kakao.maps.Map(mapContainer, mapOption);
        window.ps = new kakao.maps.services.Places();
        window.geocoder = new kakao.maps.services.Geocoder();
        window.infowindow = new kakao.maps.InfoWindow({ zIndex: 1 });

        window.nearbyMarkers = [];
        window.currentLocationMarker = null;
        window.storePositions = [
          { title: 'PetGPT 강남점', latlng: new kakao.maps.LatLng(37.4980, 127.0276) },
          { title: 'PetGPT 홍대점', latlng: new kakao.maps.LatLng(37.5559, 126.9238) },
          { title: 'PetGPT 명동점', latlng: new kakao.maps.LatLng(37.5630, 126.9830) },
          { title: 'PetGPT 부산 서면점', latlng: new kakao.maps.LatLng(35.1578, 129.0594) },
          { title: 'PetGPT 부산 해운대점', latlng: new kakao.maps.LatLng(35.1630, 129.1639) },
          { title: 'PetGPT 대구 동성로점', latlng: new kakao.maps.LatLng(35.8694, 128.5931) },
          { title: 'PetGPT 대구 수성못점', latlng: new kakao.maps.LatLng(35.8280, 128.6150) },
          { title: 'PetGPT 인천 부평점', latlng: new kakao.maps.LatLng(37.4924, 126.7235) },
          { title: 'PetGPT 광주 충장로점', latlng: new kakao.maps.LatLng(35.1468, 126.9198) },
          { title: 'PetGPT 대전 둔산점', latlng: new kakao.maps.LatLng(36.3519, 127.3850) },
          { title: 'PetGPT 울산 삼산점', latlng: new kakao.maps.LatLng(35.5390, 129.3380) },
          { title: 'PetGPT 수원 인계점', latlng: new kakao.maps.LatLng(37.2670, 127.0300) },
          { title: 'PetGPT 춘천 명동점', latlng: new kakao.maps.LatLng(37.8811, 127.7299) },
          { title: 'PetGPT 강릉 교동점', latlng: new kakao.maps.LatLng(37.7640, 128.8980) },
          { title: 'PetGPT 청주 성안길점', latlng: new kakao.maps.LatLng(36.6350, 127.4890) },
          { title: 'PetGPT 전주 객사점', latlng: new kakao.maps.LatLng(35.8170, 127.1480) },
          { title: 'PetGPT 창원 상남점', latlng: new kakao.maps.LatLng(35.2280, 128.6810) },
          { title: 'PetGPT 제주 노형점', latlng: new kakao.maps.LatLng(33.4850, 126.4800) },
          { title: 'PetGPT 서울 잠실점', latlng: new kakao.maps.LatLng(37.5146, 127.1060) },
          { title: 'PetGPT 서울 종로점', latlng: new kakao.maps.LatLng(37.5720, 126.9810) },
          { title: 'PetGPT 서울 신촌점', latlng: new kakao.maps.LatLng(37.5598, 126.9423) },
          { title: 'PetGPT 부산 남포동점', latlng: new kakao.maps.LatLng(35.0995, 129.0320) },
          { title: 'PetGPT 부산 센텀시티점', latlng: new kakao.maps.LatLng(35.1710, 129.1290) },
          { title: 'PetGPT 대구 칠곡점', latlng: new kakao.maps.LatLng(35.9430, 128.5550) },
          { title: 'PetGPT 대구 상인점', latlng: new kakao.maps.LatLng(35.8180, 128.5380) },
          { title: 'PetGPT 인천 송도점', latlng: new kakao.maps.LatLng(37.3940, 126.6500) },
          { title: 'PetGPT 인천 구월점', latlng: new kakao.maps.LatLng(37.4510, 126.7050) },
          { title: 'PetGPT 광주 상무점', latlng: new kakao.maps.LatLng(35.1510, 126.8510) },
          { title: 'PetGPT 광주 수완점', latlng: new kakao.maps.LatLng(35.1900, 126.8100) },
          { title: 'PetGPT 대전 유성점', latlng: new kakao.maps.LatLng(36.3610, 127.3400) },
          { title: 'PetGPT 대전 은행동점', latlng: new kakao.maps.LatLng(36.3280, 127.4280) },
          { title: 'PetGPT 울산 동구점', latlng: new kakao.maps.LatLng(35.5100, 129.4200) },
          { title: 'PetGPT 수원 영통점', latlng: new kakao.maps.LatLng(37.2500, 127.0700) },
          { title: 'PetGPT 성남 분당점', latlng: new kakao.maps.LatLng(37.3800, 127.1180) },
          { title: 'PetGPT 고양 일산점', latlng: new kakao.maps.LatLng(37.6580, 126.7700) },
          { title: 'PetGPT 용인 수지점', latlng: new kakao.maps.LatLng(37.3200, 127.0950) },
          { title: 'PetGPT 원주 단계점', latlng: new kakao.maps.LatLng(37.3400, 127.9300) },
          { title: 'PetGPT 속초 중앙점', latlng: new kakao.maps.LatLng(38.2050, 128.5900) },
          { title: 'PetGPT 충주 연수점', latlng: new kakao.maps.LatLng(36.9800, 127.9200) },
          { title: 'PetGPT 천안 두정점', latlng: new kakao.maps.LatLng(36.8300, 127.1450) },
          { title: 'PetGPT 군산 수송점', latlng: new kakao.maps.LatLng(35.9680, 126.7100) },
          { title: 'PetGPT 익산 영등점', latlng: new kakao.maps.LatLng(35.9450, 126.9500) },
          { title: 'PetGPT 목포 하당점', latlng: new kakao.maps.LatLng(34.8000, 126.4100) },
          { title: 'PetGPT 여수 학동점', latlng: new kakao.maps.LatLng(34.7500, 127.6600) },
          { title: 'PetGPT 순천 연향점', latlng: new kakao.maps.LatLng(34.9400, 127.5200) },
          { title: 'PetGPT 포항 양덕점', latlng: new kakao.maps.LatLng(36.0700, 129.3800) },
          { title: 'PetGPT 구미 인동점', latlng: new kakao.maps.LatLng(36.1000, 128.4000) },
          { title: 'PetGPT 경주 황성점', latlng: new kakao.maps.LatLng(35.8600, 129.2000) },
          { title: 'PetGPT 김해 내외점', latlng: new kakao.maps.LatLng(35.2350, 128.8700) },
          { title: 'PetGPT 진주 평거점', latlng: new kakao.maps.LatLng(35.1750, 128.0700) },
          { title: 'PetGPT 거제 고현점', latlng: new kakao.maps.LatLng(34.8900, 128.6200) },
          { title: 'PetGPT 제주 시청점', latlng: new kakao.maps.LatLng(33.4990, 126.5310) },
          { title: 'PetGPT 서귀포 올레시장점', latlng: new kakao.maps.LatLng(33.2480, 126.5600) }
        ];
      });

      function searchAddress() {
        var keyword = document.getElementById('address').value;
        if (!keyword) {
          alert('검색어를 입력해주세요.');
          return;
        }

        if (currentLocationMarker) {
          currentLocationMarker.setMap(null);
          currentLocationMarker = null;
        }

        removeNearbyMarkers();

        ps.keywordSearch(keyword, function (data, status, pagination) {
          if (status === kakao.maps.services.Status.OK) {
            var coords = new kakao.maps.LatLng(data[0].y, data[0].x);

            var locationImageSrc = '<c:url value="/img/icon/location-pin.png"/>',
              locationImageSize = new kakao.maps.Size(48, 48),
              locationImageOption = { offset: new kakao.maps.Point(24, 48) };

            var locationMarkerImage = new kakao.maps.MarkerImage(locationImageSrc, locationImageSize, locationImageOption);

            currentLocationMarker = new kakao.maps.Marker({
              map: map,
              position: coords,
              image: locationMarkerImage
            });

            map.setCenter(coords);
            map.setLevel(7);

            displayNearbyStores(coords);

          } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
            alert('검색 결과가 존재하지 않습니다.');
          } else if (status === kakao.maps.services.Status.ERROR) {
            alert('검색 중 오류가 발생했습니다.');
          } else {
            alert('검색 중 알 수 없는 오류가 발생했습니다.');
          }
        });
      }

      function displayNearbyStores(centerCoords) {
        var searchRadius = 10000;
        var found = false;
        var bounds = new kakao.maps.LatLngBounds();

        bounds.extend(centerCoords);

        storePositions.forEach(function (store) {
          var storeCoords = store.latlng;
          var distance = getDistance(centerCoords.getLat(), centerCoords.getLng(), storeCoords.getLat(), storeCoords.getLng());

          if (distance <= searchRadius) {
            displayStoreMarker(store, distance);
            bounds.extend(storeCoords);
            found = true;
          }
        });

        if (!found) {
          alert('반경 ' + (searchRadius / 1000) + 'km 내에 매장이 없습니다.');
        } else {
          map.setBounds(bounds);
        }
      }

      function displayStoreMarker(store, distance) {
        var storeImageSrc = '<c:url value="/img/icon/store-marker.png"/>',
          storeImageSize = new kakao.maps.Size(48, 48),
          storeImageOption = { offset: new kakao.maps.Point(24, 48) };

        var storeMarkerImage = new kakao.maps.MarkerImage(storeImageSrc, storeImageSize, storeImageOption);

        var marker = new kakao.maps.Marker({
          map: map,
          position: store.latlng,
          title: store.title,
          image: storeMarkerImage
        });

        var distanceInKm = (distance / 1000).toFixed(1);

        nearbyMarkers.push(marker);
      }

      function removeNearbyMarkers() {
        if (nearbyMarkers && nearbyMarkers.length) {
          for (var i = 0; i < nearbyMarkers.length; i++) {
            if (nearbyMarkers[i] && typeof nearbyMarkers[i].setMap === 'function') {
              nearbyMarkers[i].setMap(null);
            }
          }
        }
        nearbyMarkers = [];
      }

      function getDistance(lat1, lon1, lat2, lon2) {
        function deg2rad(deg) {
          return deg * (Math.PI / 180)
        }
        var R = 6371;
        var dLat = deg2rad(lat2 - lat1);
        var dLon = deg2rad(lon2 - lon1);
        var a =
          Math.sin(dLat / 2) * Math.sin(dLat / 2) +
          Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
          Math.sin(dLon / 2) * Math.sin(dLon / 2)
          ;
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        var d = R * c;
        return d * 1000;
      }
    </script>

    <!-- Breadcrumb Section Begin -->
    <section class="breadcrumb-option">
      <div class="container">
        <div class="row">
          <div class="col-lg-12">
            <div class="breadcrumb__text">
              <h4>About Us</h4>
              <div class="breadcrumb__links">
                <a href="<c:url value='/'/>">Home</a>
                <span>About Us</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <!-- Breadcrumb Section End -->


    <!-- Offline Store Location Section Begin -->
    <section class="map spad" style="margin-bottom: 300px;">
      <div class="container">
        <div class="row">
          <div class="col-lg-12">
            <div class="section-title">
              <span>Find Our Stores</span>
              <h2>내 주변 매장 찾기</h2>
            </div>
            <!-- Search Input and Button -->
            <div style="margin-bottom: 20px; text-align: center;">
              <input type="text" id="address" placeholder="동, 면, 읍 또는 주소 입력"
                style="padding: 10px; width: 300px; border: 1px solid #e1e1e1; margin-right: 5px;">
              <button onclick="searchAddress()" class="site-btn">검색</button>
            </div>
            <div id="map" style="width:100%;height:500px;"></div>
          </div>
        </div>
      </div>
    </section>
    <!-- Offline Store Location Section End -->

    <!-- PetGPT Info Section Begin -->
    <section class="petgpt-info spad" style="padding-top: 100px; margin-bottom: 0px;">
      <div class="container">
        <div class="row">
          <div class="col-lg-12">
            <div class="section-title">
              <span>Our Story & Vision</span>
              <h2>PetGPT 이야기</h2>
            </div>
          </div>
        </div>


        <div class="row" style="margin-bottom: 40px;">
          <div class="col-lg-12">
            <div class="about__item">
              <h4>🚀 PetGPT는 어떻게 시작되었나요?</h4>
              <p>PetGPT는 2025년, 반려동물을 향한 깊은 사랑과 이해를 바탕으로 시작되었습니다. 저희는 모든 반려인이 전문가 수준의 지식과 정보를 쉽게 얻어, 사랑하는 반려동물과 더욱
                행복한
                삶을 누릴 수 있도록 돕고자 합니다. 방대한 데이터를 기반으로 한 AI 기술을 통해, 각 반려동물에게 꼭 맞는 맞춤형 정보와 솔루션을 제공하는 것을 목표로 합니다.</p>
            </div>
          </div>
        </div>


        <div class="row" style="margin-bottom: 40px;">
          <div class="col-lg-12">
            <div class="about__item">
              <h4>💡 PetGPT의 핵심 가치</h4>
              <p><strong>데이터 기반의 신뢰성:</strong> 수많은 반려동물 데이터와 고객 행동 패턴 분석을 통해 가장 정확하고 신뢰할 수 있는 정보를 제공합니다.<br>
                <strong>사용자 중심 사고:</strong> 반려인의 입장에서 생각하며, 가장 필요하고 편리한 기능과 서비스를 개발하기 위해 노력합니다.<br>
                <strong>끊임없는 혁신:</strong> 빠르게 변화하는 기술 트렌드에 발맞춰, AI 기술을 활용한 새로운 아이디어를 지속적으로 발굴하고 실험합니다.<br>
                <strong>건강한 반려문화 조성:</strong> 올바른 정보 제공을 통해 책임감 있는 반려문화를 만들어가는 데 기여합니다.
              </p>
            </div>
          </div>
        </div>


        <div class="row" style="margin-bottom: 40px;">
          <div class="col-lg-12">
            <div class="about__item">
              <h4>🌟 PetGPT가 꿈꾸는 미래</h4>
              <p><strong>쉬운 만렙 집사 되기:</strong> PetGPT와 함께라면 누구나 반려동물 전문가가 될 수 있습니다. 초보 집사도 쉽고 똑똑하게 반려동물을 돌볼 수 있도록
                최고의
                제품 정보, 건강 관리 팁, 행동 분석 등 맞춤형 콘텐츠를 제공합니다.<br>
                <strong>반려동물 건강 우선:</strong> PetGPT는 엄격한 기준을 통해 반려동물의 건강에 도움이 되는 정보와 제품만을 추천합니다.<br>
                <strong>통합 반려 생활 플랫폼:</strong> 쇼핑, 건강 상담, 커뮤니티, O2O 서비스 연동까지, 반려 생활에 필요한 모든 것을 PetGPT 안에서 해결할 수 있도록
                발전해나갈 것입니다.<br>
                <strong>사회적 책임 실천:</strong> 유기동물 문제 해결에 관심을 기울이고, 성숙한 반려동물 문화를 만들어가는 데 앞장서겠습니다.
              </p>
            </div>
          </div>
        </div>


        <div class="row">
          <div class="col-lg-12">
            <div class="about__item">
              <h4>🤝 함께 성장하는 문화</h4>
              <p>PetGPT 팀은 반려동물 시장을 선도하는 서비스를 만들기 위해 열정적으로 협력합니다. 우리는 실패를 두려워하지 않고 끊임없이 배우며 성장합니다. 성공적인 실험은 더욱 발전시켜
                독보적인 경쟁력을 만들고, 모든 구성원이 즐겁게 일하며 서로 존중하는 수평적인 문화를 만들어갑니다.</p>
            </div>
          </div>
        </div>
      </div>
    </section>
    <!-- PetGPT Info Section End -->


    <!-- Team Section Begin -->
    <section class="team spad">
      <div class="container">
        <div class="row">
          <div class="col-lg-12">
            <div class="section-title">
              <span>Our Team</span>
              <h2>팀을 소개합니다</h2>
            </div>
          </div>
        </div>
        <div class="row">

          <div class="col-lg-4 col-md-6 col-sm-6">
            <div class="team__item" style="text-align: center;">
              <img src="<c:url value='/img/about/woman.png'/>" alt="강성경">
              <h4>강성경</h4>
              <span>Developer</span>
            </div>
          </div>

          <div class="col-lg-4 col-md-6 col-sm-6">
            <div class="team__item" style="text-align: center;">
              <img src="<c:url value='/img/about/woman.png'/>" alt="김민주">
              <h4>김민주</h4>
              <span>Developer</span>
            </div>
          </div>

          <div class="col-lg-4 col-md-6 col-sm-6">
            <div class="team__item" style="text-align: center;">
              <img src="<c:url value='/img/about/man.png'/>" alt="김상우">
              <h4>김상우</h4>
              <span>Developer</span>
            </div>
          </div>
        </div>
        <div class="row justify-content-center">

          <div class="col-lg-4 col-md-6 col-sm-6">
            <div class="team__item" style="text-align: center;">
              <img src="<c:url value='/img/about/man.png'/>" alt="김준서">
              <h4>김준서</h4>
              <span>Developer</span>
            </div>
          </div>

          <div class="col-lg-4 col-md-6 col-sm-6">
            <div class="team__item" style="text-align: center;">

              <img src="<c:url value='/img/about/man.png'/>" alt="김현호">
              <h4>김현호</h4>
              <span>Developer</span>
            </div>
          </div>
        </div>
      </div>
    </section>
    <!-- Team Section End -->