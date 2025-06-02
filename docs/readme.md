# **PetGPT 🐶**

PM (Project Manager): 김민주  
DEV: 강성경, 김현호, 김상우, 김준서  
기간: 2025.03.24 ~ 2025.05.31

- **웹 시연 영상**: \[여기에 링크 추가\]
- **노션 링크**: \[여기에 링크 추가\]

&nbsp;

![썸네일](./images/thumbnail.png)

&nbsp;

## **프로젝트 소개**

### 주제

```
AI 서비스 기반 반려동물 쇼핑몰: RAG 챗봇 상담 및 이미지 인식, 화면 인식 등 편의 기능을 제공합니다.
```

&nbsp;

### 기획의도

반려동물 양육 인구가 급증함에 따라 관련 용품 시장도 빠르게 성장하고 있지만, 수많은 상품 정보 속에서 내 반려동물에게 꼭 필요한 제품을 찾기란 쉽지 않습니다. 특히 처음 반려동물을 키우거나 특정 상황(질병, 알레르기 등)에 놓인 보호자들은 어떤 기준으로 상품을 선택해야 할지 막막함을 느끼곤 합니다.

**PetGPT**는 이러한 정보 비대칭 문제를 해결하고, 보호자들이 더욱 편리하고 현명하게 쇼핑할 수 있는 환경을 제공하고자 기획되었습니다. RAG(Retrieval Augmented Generation) 기반 AI 챗봇 상담과 이미지 인식을 통한 품종 분석 등 AI 편의 기능을 통해 고객 맞춤형 쇼핑 경험을 제공합니다.

&nbsp;

## **기술 스택**

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

\[ERD 이미지 또는 설명\]

&nbsp;

## **✨ 주요 기능**

### **사용자 페이지**

1. **상품 조회**

&nbsp;

2. **커뮤니티**

&nbsp;

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

&nbsp;

### **관리자 페이지**

1. **상품 및 재고 관리 (CRUD)**
   - 상품 정보 등록, 수정, 삭제 기능
   - 실시간 재고 현황 파악 및 관리
   - \[관리자 상품 관리 화면 스크린샷 또는 GIF\]
2. **주문 및 배송 관리**
   - 주문 내역 확인 및 상태 변경 (결제 완료, 배송 중, 배송 완료 등)
   - \[관리자 주문 관리 화면 스크린샷 또는 GIF\]
3. **고객 관리**
   - 회원 정보 조회 및 관리
   - \[관리자 고객 관리 화면 스크린샷 또는 GIF\]
4. **통계 확인**
   - 매출, 상품별 판매량 등 주요 지표 시각화
   - \[관리자 통계 화면 스크린샷 또는 GIF\]

&nbsp;

## **🔧 일반 기능**

### **사용자 페이지**

### **관리자 페이지**

&nbsp;

## **📊 WBS (Work Breakdown Structure)**

\[WBS 내용\]

&nbsp;

## **🚀 USER-FLOW**

![USER_FLOW](./images/유저_플로우.png)

&nbsp;

## **🚀 ADMIN-FLOW**

\[관리자 로그인 → 상품 관리(등록/수정/삭제) → 주문 관리 → 고객 관리 → 통계 확인\]

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
