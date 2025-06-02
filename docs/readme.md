# **PetGPT 🐶😸**

### 🎬 시연 영상 : [링크]()

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

## **⚙️ 프로젝트 로드맵**

![프로젝트_로드맵](./images/roadmap.png)

&nbsp;

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

- **카테고리별 게시글 조회** (공지사항, 자유게시판, 펫자랑게시판 등)
- **게시글 작성/수정/삭제**: Summernote 에디터, Papago API를 이용한 텍스트 번역 기능, 게시글 이미지 업로드 기능
- **댓글**: 게시글에 대한 댓글 작성, 수정, 삭제, 좋아요 기능
- **게시글 좋아요**: 게시글에 대한 '좋아요' 기능
- **검색**: 게시글 제목 검색

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

&nbsp;

5. **Google Cloud Vision API 활용 품종 분석**

   - 사용자가 업로드한 반려동물 사진 분석하여 크기, 성격, 털관리, 활동량 4가지 정보 제공

   - ![이미지_분석](./images/ai_analysis.png)

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

     ![실시간_채팅_1](./images/chat1.png)

     ![실시간_채팅_2](./images/chat2.png)

     &nbsp;

9. **스케줄러를 활용한 타임딜 이벤트**

   - 지정된 시간에 특정 상품을 할인된 가격으로 제공하는 타임딜 기능을 스케줄러를 통해 자동화
   - 주기적인 이벤트를 효율적으로 운영하고 사용자의 구매를 유도

     ![타임딜_1](./images/time_deal1.png)

     ![타임딜_2](./images/time_deal2.png)

     ![타임딜_3](./images/time_deal3.png)

10. **다크 모드/라이트 모드**: UI 테마 변경 기능

&nbsp;

### **관리자 페이지**

1. **관리자 로그인및 메인화면**

   - 관리자 로그인
   - 디자인 : 다크모드/라이트모드, 메뉴별 사계절 테마 적용
   - shop 데이터 통계 - 전체 사용자 수 , 전체 상품 수 ,오늘 가입자 수, 총 주문수
     총 매출액 , 배송상태, 최근 7일 매출 추이, 카테고리별 판매 통계
   - 상품판매량 Top 10순위, 관리자 공지사항, 최근 주문내역, 최근 문의사항

     ![어드민메인](./adminimages/main.gif)

2. **사용자(고객 관리)**

   - 회원 정보 조회 및 관리
     ![어드민고객관리](./adminimages/customer.gif)

3. **상품 및 재고 관리 (CRUD)**

   - 상품 정보 등록, 수정, 삭제 기능
   - 실시간 재고 현황 파악 및 관리
   - 상품별 문의글 보기
     ![어드민상품관리](./adminimages/item.gif)

4. **주문 및 배송 관리**

   - 주문 내역 확인 및 상태 변경 (결제 완료, 배송 중, 배송 완료 등)
     ![어드민주문관리](./adminimages/order.gif)

5. **문의글 관리**

   - 상품 문의 게시판
   - 답변글 등록, 수정, 삭제
   - AI 자동응답제안 - 자동 응답 생성
     ![어드민문의글관리](./adminimages/qna.gif)

6. **공지관리**

   - 관리자 공지사항 등록, 수정, 삭제 관리
   - CKEditor API사용
     ![어드민통계](./adminimages/noti.gif)

7. ** 사이트 통계 **
   - 매출, 고객변동, 상품별 판매량 등 주요 지표 시각화
   - 지역별 매출 Kakaomap API
     ![어드민통계](./adminimages/statistics.gif)

&nbsp;

## **📊 WBS (Work Breakdown Structure)**

- [🚗 Visit WBS](https://docs.google.com/spreadsheets/d/1WaKkOoaokv8sxJsjjT0YFSjdwtI9_H0zxr2BZEEwtgI/edit?gid=130692905#gid=130692905)
  &nbsp;

## **🚀 USER-FLOW**

![USER_FLOW](./images/유저_플로우.png)

&nbsp;

## **🚀 ADMIN-FLOW**

![Admin Flow](./images/adminFlow.png)

&nbsp;

## **🤔 트러블 슈팅 (Troubleshooting)**

- **문제 1**: \[문제 상황 요약\]
  - **원인**: \[문제 발생 원인\]
  - **해결**: \[해결 방법 및 과정\]

&nbsp;

## **💡 프로젝트를 통해 배운 점 및 느낀 점**

- **강성경**: \[내용\]
- **김민주**: \[내용\]
- **김준서**: \[내용\]
- **김상우**: \[내용\]
- **김현호**: \[내용\]
