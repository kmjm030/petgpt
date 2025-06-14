# 고객 정보 상세 (Customer Table)

- **고객 ID: catlover01**

  - 비밀번호: pass1234
  - 이름: 김고양
  - 이메일: cat01@email.com
  - 전화번호: 010-1111-1111
  - 가입일: (DML 기준 NOW() - INTERVAL 30 DAY)
  - 권한: 0 (일반사용자)
  - 포인트: 1200
  - 닉네임: 냥이짱
  - 프로필 이미지: (없음)
  - 최근 포인트 변동액: 1000
  - 포인트 변동 사유: 회원가입
  - **보유 쿠폰 (`coupon` 테이블):**
    - 쿠폰 ID 1: 3000원 할인쿠폰 (정액, 할인액 3000원), 발행일: (DML 기준 CURDATE() - INTERVAL 5 DAY), 만료일: (DML 기준 DATE_ADD(CURDATE(), INTERVAL 25 DAY)), 상태: 미사용
    - 쿠폰 ID 9: 30% 할인쿠폰 (정률, 할인율 30%, 최대할인액 10000원), 발행일: (DML 기준 CURDATE()), 만료일: (DML 기준 DATE_ADD(CURDATE(), INTERVAL 30 DAY)), 상태: 미사용
  - **등록된 펫 (`pet` 테이블):**
    - 펫 ID: (Auto Increment)
    - 펫 이름: 냥냥이, 종류: 고양이, 품종: 코리안숏헤어, 생일: 2022-03-15, 성별: F, 이미지: cat_nyangnyang.jpg, 등록일: (DML 기준 NOW() - INTERVAL 20 DAY)
  - **주문 내역 (`total_order` 테이블):**
    - 주문번호 1: 상품 (고양이 후리스 조끼), 총액 15,900원, 배송완료
  - **작성한 Q&A/리뷰 (`qnaboard` 테이블):**
    - 게시글 ID 1: (리뷰) 고양이 후리스 조끼 - "후리스 조끼 따뜻하고 최고!" (별점 5)
  - **좋아요 한 상품 (`like` 테이블):**
    - 상품 ID 10 (고양이 후리스 조끼)
    - 상품 ID 72 (고양이 공 터널)
  - **최근 본 상품 (`recent_view` 테이블):**
    - 상품 ID 10 (고양이 후리스 조끼)
    - 상품 ID 72 (고양이 공 터널)
  - **작성한 커뮤니티 게시글 (`communityboard` 테이블):**
    - 게시글 ID 2: (펫자랑) "우리 냥이 새 후드티! 펫GPT에서 득템했어요 💖" (상품 ID 13 연관)
    - 게시글 ID 12: (상품후기) "우리집 냥냥펀치! 펫GPT 레이저 포인터 후기 🌟" (상품 ID 71 연관)
  - **작성한 커뮤니티 댓글 (`comments` 테이블):**
    - 게시글 ID 1 (시스템 공지) 댓글: "오! 드디어 기다리던 할인전이네요! 감사합니다."
  - **좋아요 한 커뮤니티 댓글 (`comment_likes` 테이블):**
    - 게시글 ID 1의 댓글 ID 2 (dogleader 작성)에 좋아요

- **고객 ID: dogfan02**

  - 비밀번호: pass5678
  - 이름: 박강아
  - 이메일: dog02@email.com
  - 전화번호: 010-2222-2222
  - 가입일: (DML 기준 NOW() - INTERVAL 25 DAY)
  - 권한: 0 (일반사용자)
  - 포인트: 3500
  - 닉네임: 댕댕미소
  - 프로필 이미지: (없음)
  - 최근 포인트 변동액: 3000
  - 포인트 변동 사유: 첫구매
  - **보유 쿠폰 (`coupon` 테이블):**
    - 쿠폰 ID 2: 10% 할인쿠폰 (정률, 할인율 10%, 최대할인액 5000원), 발행일: (DML 기준 CURDATE() - INTERVAL 3 DAY), 만료일: (DML 기준 DATE_ADD(CURDATE(), INTERVAL 12 DAY)), 상태: 미사용
  - **등록된 펫 (`pet` 테이블):**
    - 펫 ID: (Auto Increment)
    - 펫 이름: 멍뭉이, 종류: 강아지, 품종: 말티즈, 생일: 2023-01-20, 성별: M, 이미지: dog_mungmung.jpg, 등록일: (DML 기준 NOW() - INTERVAL 15 DAY)
  - **주문 내역 (`total_order` 테이블):**
    - 주문번호 2: 상품 (강아지 방울 니트), 총액 17,910원, 배송중
  - **작성한 Q&A/리뷰 (`qnaboard` 테이블):**
    - 게시글 ID 2: (리뷰) 강아지 방울 니트 - "방울 니트 너무 귀여워요!" (별점 5)
  - **좋아요 한 상품 (`like` 테이블):**
    - 상품 ID 20 (강아지 방울 니트)
    - 상품 ID 81 (강아지 봉제 뼈다귀)
  - **최근 본 상품 (`recent_view` 테이블):**
    - 상품 ID 20 (강아지 방울 니트)
  - **좋아요 한 커뮤니티 게시글 (`post_likes` 테이블):**
    - 게시글 ID 1 (시스템 공지)에 좋아요

- **고객 ID: mintycat**
  - 비밀번호: mint2024
  - 이름: 이민트
  - 이메일: mint@cat.com
  - 전화번호: 010-3333-3333
  - 가입일: (DML 기준 NOW() - INTERVAL 20 DAY)
  - 권한: 0 (일반사용자)
  - 포인트: 780
  - 닉네임: 민트냥이
  - 프로필 이미지: (없음)
  - 최근 포인트 변동액: 500
  - 포인트 변동 사유: 이벤트
  - **보유 쿠폰 (`coupon` 테이블):**
    - 쿠폰 ID 3: 5000원 할인쿠폰 (정액, 할인액 5000원), 발행일: (DML 기준 CURDATE() - INTERVAL 7 DAY), 만료일: (DML 기준 DATE_ADD(CURDATE(), INTERVAL 23 DAY)), 상태: 미사용
  - **등록된 펫 (`pet` 테이블):**
    - 펫 ID: (Auto Increment)
    - 펫 이름: 민트, 종류: 고양이, 품종: 스코티시폴드, 생일: 2021-07-07, 성별: N, 이미지: (없음), 등록일: (DML 기준 NOW() - INTERVAL 10 DAY)
  - **주문 내역 (`total_order` 테이블):**
    - 주문번호 4: 상품 (고양이 슬로우 식기, 고양이 방수 방석), 총액 34,400원, 결제완료
  - **작성한 Q&A/리뷰 (`qnaboard` 테이블):**
    - 게시글 ID 5: (문의) 고양이 레이저 포인터 - "레이저 포인터 건전지 어떤 거 사용하나요?"
  - **좋아요 한 상품 (`like` 테이블):**
    - 상품 ID 33 (고양이 슬로우 식기)
  - **최근 본 상품 (`recent_view` 테이블):**
    - 상품 ID 33 (고양이 슬로우 식기)
  - **작성한 커뮤니티 게시글 (`communityboard` 테이블):**
    - 게시글 ID 5: (질문있어요) "고양이 슬로우 식기, 펫GPT에서 파는 거 써보신 분?" (상품 ID 33 연관)
    - 게시글 ID 15: (질문있어요) "고양이 헤어볼 케어 사료, 펫GPT 제품 효과 있나요? 😥" (상품 ID 130 연관)
  - **작성한 커뮤니티 댓글 (`comments` 테이블):**
    - 게시글 ID 1 (시스템 공지)에 대한 대댓글: "어떤 상품들이 할인 대상인지 궁금하네요~"
    - 게시글 ID 2 (catlover01의 펫자랑) 댓글: "후드티 너무 예뻐요! 어디서 사셨는지 정보 좀 알 수 있을까요?"
  - **좋아요 한 커뮤니티 게시글 (`post_likes` 테이블):**
    - 게시글 ID 1 (시스템 공지)에 좋아요

---
