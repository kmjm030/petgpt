<%@ page pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
              <span>Our Stores</span>
              <h2>오프라인 매장 위치</h2>
            </div>
            <div style="margin-bottom: 20px; text-align: center;">
              <button onclick="panTo(37.5665, 126.9780)" class="site-btn">서울</button>
              <button onclick="panTo(36.3504, 127.3845)" class="site-btn">대전</button>
              <button onclick="panTo(35.8714, 128.6014)" class="site-btn">대구</button>
              <button onclick="panTo(35.1796, 129.0756)" class="site-btn">부산</button>
            </div>
            <div id="map" style="width:100%;height:400px;"></div>
          </div>
        </div>
      </div>
    </section>
    <!-- Offline Store Location Section End -->


    <script type="text/javascript"
      src="//dapi.kakao.com/v2/maps/sdk.js?appkey=1d80cc061f948248f9465d96f87b1f5c"></script>
    <script>
      var mapContainer = document.getElementById('map');
      mapOption = {
        center: new kakao.maps.LatLng(36.3504, 127.3845),
        level: 7
      };

      var map = new kakao.maps.Map(mapContainer, mapOption);


      var positions = [
        {
          title: '서울 매장',
          latlng: new kakao.maps.LatLng(37.5665, 126.9780)
        },
        {
          title: '대전 매장',
          latlng: new kakao.maps.LatLng(36.3504, 127.3845)
        },
        {
          title: '대구 매장',
          latlng: new kakao.maps.LatLng(35.8714, 128.6014)
        },
        {
          title: '부산 매장',
          latlng: new kakao.maps.LatLng(35.1796, 129.0756)
        }
      ];


      for (var i = 0; i < positions.length; i++) {


        var marker = new kakao.maps.Marker({
          map: map,
          position: positions[i].latlng,
          title: positions[i].title
        });
      }


      function panTo(lat, lng) {
        var moveLatLon = new kakao.maps.LatLng(lat, lng);

        map.panTo(moveLatLon);

      }
    </script>


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