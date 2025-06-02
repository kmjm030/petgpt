# **PetGPT 🐶😸**

&nbsp;

## 🎬 시연 영상 : [링크]()

PM (Project Manager): 김민주  
DEV: 강성경, 김현호, 김상우, 김준서  
기간: 2025.03.24 ~ 2025.05.31

&nbsp;

![썸네일](./images/thumbnail.png)

&nbsp;

<div align="center">
  
| 분류       | 기술 스택 |
| ---------- | ---------- |
| **개발 언어** | ![Java](https://img.shields.io/badge/Java-007396?style=flat&logo=oracle&logoColor=white) ![HTML](https://img.shields.io/badge/HTML5-E34F26?style=flat&logo=html5&logoColor=white) ![CSS](https://img.shields.io/badge/CSS3-1572B6?style=flat&logo=css3&logoColor=white) ![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black) |
| **프레임워크 & 라이브러리** | ![Spring Boot](https://img.shields.io/badge/Spring%20Boot-6DB33F?style=flat&logo=springboot&logoColor=white) ![MyBatis](https://img.shields.io/badge/MyBatis-BB1A1A?style=flat&logo=MyBatis&logoColor=white) ![JSP](https://img.shields.io/badge/JSP-007396?style=flat&logo=java&logoColor=white) ![Bootstrap](https://img.shields.io/badge/Bootstrap-7952B3?style=flat&logo=bootstrap&logoColor=white) |
| **IDE** | ![IntelliJ IDEA](https://img.shields.io/badge/IntelliJ-000000?style=flat&logo=intellijidea&logoColor=white) ![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-007ACC?logo=visualstudiocode&logoColor=fff)|
| **협업 도구** | ![Discord](https://img.shields.io/badge/Discord-5865F2?style=flat&logo=discord&logoColor=white) ![Zoom](https://img.shields.io/badge/Zoom-2D8CFF?style=flat&logo=zoom&logoColor=white)  ![Git](https://img.shields.io/badge/Git-F05032?style=flat&logo=Git&logoColor=white) ![Github](https://img.shields.io/badge/Github-181717?style=flat&logo=Github&logoColor=white) |
| **DB** | ![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white) |
| **API** | ![Gemini AI](https://img.shields.io/badge/Gemini%20AI-FF6F61?style=flat)  ![OPENAI](https://img.shields.io/badge/-OpenAI-eee?style=flat-square&logo=openai&logoColor=412991)|
| **서버 배포** | ![NCP](https://img.shields.io/badge/Naver%20Cloud-03C75A?style=flat&logo=naver&logoColor=white) |

</div>

&nbsp;

## **✨ 프로젝트 소개**

### 주제

```
AI 서비스 기반 반려동물 쇼핑몰: RAG 챗봇 상담 및 이미지 인식, 화면 인식 등 편의 기능을 제공합니다.
```

&nbsp;

### 기획의도

반려동물 양육 인구가 급증함에 따라 관련 용품 시장도 빠르게 성장하고 있지만, 수많은 상품 정보 속에서 내 반려동물에게 꼭 필요한 제품을 찾기란 쉽지 않습니다. 특히 처음 반려동물을 키우거나 특정 상황(질병, 알레르기 등)에 놓인 보호자들은 어떤 기준으로 상품을 선택해야 할지 막막함을 느끼곤 합니다.

**PetGPT**는 이러한 정보 비대칭 문제를 해결하고, 보호자들이 더욱 편리하고 현명하게 쇼핑할 수 있는 환경을 제공하고자 기획되었습니다. RAG(Retrieval Augmented Generation) 기반 AI 챗봇 상담과 이미지 인식을 통한 품종 분석 등 AI 편의 기능을 통해 고객 맞춤형 쇼핑 경험을 제공합니다.

&nbsp;

## **🛠️ 기술 스택**

| 구분          | 내용                                                                                                 |
| :------------ | :--------------------------------------------------------------------------------------------------- |
| **IDE**       | IntelliJ IDEA, Visual Studio Code, Cursor                                                            |
| **Language**  | Java, JavaScript, Python                                                                             |
| **Framework** | Spring Boot, MyBatis, JSP (View)                                                                     |
| **Database**  | MySQL, Pinecone                                                                                      |
| **Server**    | Apache Tomcat, Naver Cloud Platform                                                                  |
| **VCS**       | Git, GitHub                                                                                          |
| **APIs**      | 카카오 소셜 로그인 API, 카카오 맵 API, 아임포트 결제 API, Google Cloud Vision API, Google Gemini API |
| **Tools**     | ERDCloud, Slack, Notion, Miro                                                                        |
| **기타**      | LangChain                                                                                            |

&nbsp;

## **🗺️ 프로젝트 로드맵**

![프로젝트_로드맵](./images/roadmap.png)

&nbsp;

## **📚 RAG 시스템 아키텍처 다이어그램**

![PetGPT_시스템_아키텍처_다이어그램](./images/PetGPT_시스템_아키텍처_다이어그램.png)

&nbsp;

## **🗂️ ERD (데이터베이스 설계)**

![ERD](./images/ERD.png)

&nbsp;

## **✨ 주요 기능**

### **사용자 페이지**

1. **상품 관리**

- **상품 상세 조회**: 카테고리별 상품 조회, 상품 상세 정보 확인 기능
- **필터링**: 다양한 조건 (가격, 사이즈, 색상 등)으로 상품 필터링
- **정렬**: 최신순, 오래된순, 가격 높은순/낮은순, 판매량순, 할인율순 등 다양한 기준으로 상품을 정렬
- **검색**: 상품명 키워드 검색

&nbsp;

2. **커뮤니티**

- **정렬**

  ![커뮤니티_게시글_정렬](./images/게시글_정렬.gif)

- **게시글 작성/수정/삭제**: Summernote 에디터, Papago API를 이용한 텍스트 번역 기능, 게시글 이미지 업로드 기능

  ![커뮤니티_게시글_작성](./images/게시글_작성.gif)

  ![커뮤니티_게시글_수정_삭제](./images/게시글_수정_삭제.gif)

- **댓글**: 게시글에 대한 댓글 작성, 수정, 삭제, 좋아요 기능

  ![커뮤니티_댓글](./images/댓글.gif)

&nbsp;

3. **비밀번호 찾기/재설정**

- 이메일 인증을 통한 비밀번호 재설정

3. **RAG 기반 AI 챗봇 상품 추천 및 상담**

- [챗봇\_readme](./chatbot-readme.md)

&nbsp;

- 쇼핑몰 내부 상품 정보, 고객 리뷰, 쇼핑몰 정책 등을 학습한 AI 챗봇
- 고객 질문 의도 파악 및 맞춤형 상품 추천, 상품 비교, 관련 고객 리뷰 등 상세 답변 실시간 제공

  ![맞춤형_상품_추천](./images/chatbot1.png)

  ![상품_비교](./images/chatbot2.png)

  ![고객_리뷰](./images/chatbot5.png)

  &nbsp;

- 애매하거나 의외의 질문에 대한 예외 처리 능력

  ![예외_처리](./images/chatbot3.png)

  &nbsp;

- 의학적 질문에 대한 책임 회피 능력

  ![의학적_질문](./images/chatbot4.png)

  &nbsp;

- 채팅 목록 저장 및 세션에 대한 대화 맥락 유지 능력

  ![대화_맥락_1](./images/chatbot6.png)

  ![대화_맥락_2](./images/chatbot7.png)

  &nbsp;

4. **AI 어시스턴트 팝업**

- [AI\_어시스턴트\_팝업\_readme](./assistant-popup.md)

![어시스턴트_팝업](./images/어시스턴트_팝업.gif)

&nbsp;

5. **Google Cloud Vision API 활용 품종 분석**

   - 사용자가 업로드한 반려동물 사진 분석하여 크기, 성격, 털관리, 활동량 4가지 정보 제공
     ![이미지_분석](./images/이미지_분석.gif)

&nbsp;

6. **카카오 API 연동 (소셜 로그인, 지도 기반 서비스)**

   - 카카오 계정을 통한 간편 로그인

     ![카카오_로그인_1](./images/login1.png)

     ![카카오_로그인_2](./images/login2.png)

     &nbsp;

   - 카카오 맵 연동으로 "내 주변 매장 찾기" 검색 서비스

     ![카카오_맵](./images/kakao_map.png)

7. **아임포트 API 활용 간편 결제 시스템**

   - 다양한 결제 수단을 통한 안전하고 빠른 결제 지원
   - \[결제 진행 화면 스크린샷 또는 GIF\]

   &nbsp;

8. **실시간 채팅 상담 (WebSocket 활용)**

   - 사용자와 관리자 간 실시간 양방향 소통이 가능한 채팅 기능
   - 이를 통해 고객 문의에 대한 즉각적인 응대가 가능

   ![실시간_채팅](./images/실시간_채팅.gif)

   &nbsp;

9. **스케줄러를 활용한 타임딜 이벤트**

   - 지정된 시간에 특정 상품을 할인된 가격으로 제공하는 타임딜 기능을 스케줄러를 통해 자동화
   - 주기적인 이벤트를 효율적으로 운영하고 사용자의 구매를 유도
     ![타임딜](./images/타임딜.gif)

10. **다크 모드/라이트 모드**: UI 테마 변경 기능  
    ![다크모드](./images/다크모드.gif)

&nbsp;

### **관리자 페이지**

1. **관리자 로그인및 메인화면**

   - 관리자 로그인
   - 디자인 : 다크모드/라이트모드, 메뉴별 사계절 테마 적용
   - shop 데이터 통계 - 전체 사용자 수 , 전체 상품 수 ,오늘 가입자 수, 총 주문수
     총 매출액 , 배송상태, 최근 7일 매출 추이, 카테고리별 판매 통계
   - 상품판매량 Top 10순위, 관리자 공지사항, 최근 주문내역, 최근 문의사항

     ![어드민메인](./adminimages/main.gif)

     &nbsp;

2. **사용자(고객 관리)**

   - 회원 정보 조회 및 관리
     ![어드민고객관리](./adminimages/customer.gif)

     &nbsp;

3. **상품 및 재고 관리 (CRUD)**

   - 상품 정보 등록, 수정, 삭제 기능
   - 실시간 재고 현황 파악 및 관리
   - 상품별 문의글 보기
     ![어드민상품관리](./adminimages/item.gif)

     &nbsp;

4. **주문 및 배송 관리**

   - 주문 내역 확인 및 상태 변경 (결제 완료, 배송 중, 배송 완료 등)
     ![어드민주문관리](./adminimages/order.gif)

     &nbsp;

5. **문의글 관리**

   - 상품 문의 게시판
   - 답변글 등록, 수정, 삭제
   - AI 자동응답제안 - 자동 응답 생성
     ![어드민문의글관리](./adminimages/qna.gif)

     &nbsp;

6. **공지관리**

   - 관리자 공지사항 등록, 수정, 삭제 관리
   - CKEditor API사용
     ![어드민통계](./adminimages/noti.gif)

     &nbsp;

7. ** 사이트 통계 **
   - 매출, 고객변동, 상품별 판매량 등 주요 지표 시각화
   - 지역별 매출 Kakaomap API
     ![어드민통계](./adminimages/statistics.gif)

&nbsp;

## **📊 WBS (Work Breakdown Structure)**

![WBS](./images/wbs.png)

- [🚗 Visit WBS](https://docs.google.com/spreadsheets/d/1WaKkOoaokv8sxJsjjT0YFSjdwtI9_H0zxr2BZEEwtgI/edit?gid=130692905#gid=130692905)

&nbsp;

## **🚀 USER-FLOW**

![USER_FLOW](./images/유저_플로우.png)

&nbsp;

## **🚀 ADMIN-FLOW**

![Admin Flow](./images/adminflow.png)

&nbsp;

## **🤔 트러블 슈팅 (Troubleshooting)**

- **김민주**:

  - **문제 1**: 화면에서 이미지가 로드되지 않음
    - **원인**: jQuery의 로딩 시점(선/후)에 따라 스크립트 실행 여부가 달라질 수 있음
    - **해결**: 이미지가 JS(jQuery)로 동적으로 로드되는 구조라면, jQuery가 반드시 먼저 로드되어야 함
  - **문제 2**: 잘 사용하던 annotation이 갑자기 오류를 일으킴
    - **원인**: 캐시삭제가 제대로 되지 않음
    - **해결**: 인텔리제이에서 'invalidate cashes'를 선택해 재시작
  - **문제 3**: 문의글에서 주문내역 선택 상자가 두 개 나타나는 오류 발생
    - **원인**: select 태그 하나에 Select2, NiceSelect가 모두 적용되어 중복으로 나타남
    - **해결**: 해당 셀렉트박스에 niceSelect()가 적용되지 않도록 코드 작성

- **김준서**:

  - **문제 1**: 관리자 페이지에 particles.js를 이용해 파티클이 내리는 효과를 추가하려 했지만, 효과가 화면에 나타나지 않음.
    - **원인**: particles.min.js 스크립트가 로드되지 않음
      CDN 경로 누락 또는 인터넷 연결 문제
      <div id="particles-js">가 페이지에 없음
      JavaScript가 렌더링되기 전에 엘리먼트를 찾지 못함
      CSS 설정 누락으로 입자가 보이지 않음
      z-index, position, width, height 미지정
      스크립트가 <body>보다 먼저 실행됨
      DOM이 준비되기 전에 실행되어 canvas가 생성되지 않음
    - **해결**: 구현하지 못함

- **김상우**: \[내용\]

- **김현호**:

  - **문제**: AI 챗봇이 사용자의 질문 의도와는 다소 거리가 있거나 관련성이 낮은 정보를 포함하여 답변하는 경우가 발생했습니다. 특히, 쇼핑몰 내부 특정 상품 정보나 정책 관련 질문에 대해 기대만큼 정확한 답변을 제공하지 못했습니다.

    - **원인**: 벡터 스토어에 문서를 저장하고 임베딩할 때 사용한 청크(chunk)의 크기 및 분할 전략이 부적절했습니다. 초기에는 문서의 의미적 단위를 넓게 가져가기 위해 청크를 매우 크게 설정했습니다. 이 경우, 개별 청크가 너무 많은 정보를 포괄하게 되어 검색 시 특정 질문과 관련된 핵심 내용의 정확도가 오히려 떨어지고, 관련 없는 정보까지 함께 참조하여 답변을 생성하는 경향이 있었습니다. 반대로, 정보의 정확도를 높이고자 청크를 문장 단위 등으로 매우 잘게 분할했을 때는 개별 청크가 충분한 컨텍스트를 담지 못했습니다. 이로 인해 여러 청크에 분산된 정보를 종합적으로 이해하고 답변을 생성하는 데 어려움이 있었으며, 단편적이거나 맥락이 부족한 답변이 생성되었습니다.

    - **해결**: 다양한 청크 크기(예: 문서 전체, 문단 단위, 특정 토큰 수 기준, 문장 단위)와 분할 전략(고정 길이, 의미 기반 분할 등)을 실험적으로 적용하며 답변 품질을 지속적으로 비교 평가하여 문제를 해결했습니다.

&nbsp;

## **💡 프로젝트를 통해 배운 점 및 느낀 점**

- **강성경**: \[내용\]

- **김민주**: \[내용\]

- **김준서**:
  이번 프로젝트를 통해 단순한 기능 구현을 넘어서, 실제 사용자 관점에서 문제를 정의하고 해결하는 과정의 중요성을 깊이 체감할 수 있었습니다. 초기 설계 단계에서 요구사항을 명확히 정의하고, 그에 맞게 구조화된 코드를 작성하는 것이 유지보수성과 확장성 측면에서 얼마나 중요한지를 배웠습니다.

  또한 팀원들과의 협업 과정에서 버전 관리(Git), 이슈 트래킹, 코드 리뷰 등의 개발 문화가 프로젝트 완성도에 직접적인 영향을 미친다는 것을 느꼈습니다. 특히 의사소통과 역할 분담이 원활할수록 개발 속도와 품질이 향상된다는 점을 실감했습니다.

  무엇보다도 프로젝트를 통해 "완성된 서비스를 직접 운영해보는 경험"이 주는 자신감과 동기부여가 가장 큰 수확이었습니다. 이번 경험을 바탕으로 앞으로도 더욱 적극적이고 주도적으로 개발에 임하고 싶습니다.

- **김상우**: \[내용\]

- **김현호**:
  본 프로젝트의 기획부터 구현, 마무리까지 전 과정을 직접 수행하면서, 다음 프로젝트에서는 초기 기획 단계의 중요성을 깊이 인식하게 되었습니다. 특히 데이터베이스 구조를 설계하고, 각 기능의 세부 내용을 미리 잘 정리해두는 것이 개발 과정에서 발생할 수 있는 시행착오를 줄이고 전체적인 효율을 높이는 데 도움이 된다는 점을 깨달았습니다.

  또한 Google Vision API나 외부 챗봇처럼 인공지능 관련 서비스를 실제 애플리케이션에 연결해보면서, 새로운 기술에 대한 이해도를 높일 수 있었습니다. 이러한 경험은 앞으로 더 유용하고 실질적인 가치를 주는 서비스를 기획하고 개발하는 데 큰 도움이 될 것이라 기대합니다.

  마지막으로, 프로젝트를 진행하면서 Langchain이나 RAG 같은 새로운 기술을 직접 배우고 바로 적용해보는 과정은 단순한 이론 공부보다 더 몰입감 있게 느껴졌으며, 실제로 기술을 익히는 데 더 효과적이었습니다. 이를 통해 실전 중심의 학습 방식이 매우 유익하다는 점을 느꼈습니다.
