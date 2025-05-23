# 커뮤니티 게시판 주요 내용 (Community Board Table - 상품 미연관 중심)

- **게시글 ID: 1** (DML의 첫 번째 communityboard INSERT)

  - 작성자 ID: admin1
  - 관련 상품 ID: (없음, 시스템 공지)
  - 카테고리: 시스템 공지
  - 제목: 📢 펫GPT 7월 고객 감사 특별 할인전 안내!
  - 내용: 안녕하세요, 펫GPT입니다! 7월 한 달간 고객 감사 특별 할인전을 진행합니다. 인기 상품들을 특별한 가격으로 만나보세요! 자세한 내용은 펫GPT 이벤트 페이지를 확인해주세요.
  - 이미지: /img/product/dog_allages.jpeg
  - 조회수: (DML 기준 RAND() \* 1000) + 150
  - 좋아요 수: (post_likes 테이블 참조)
  - 댓글 수: (comments 테이블 참조)
  - 등록일: (DML 기준 NOW() - INTERVAL FLOOR(RAND()\*7) DAY - INTERVAL 1 HOUR)
  - **연관 댓글 및 좋아요:** (상품 ID 101 - 강아지 전연령 사료 부분에서 상세히 기술됨)

- **게시글 ID: 4** (DML의 네 번째 communityboard INSERT)

  - 작성자 ID: admin2
  - 관련 상품 ID: (없음, 이벤트 공지, 내용은 상품 ID 134 이미지 사용)
  - 카테고리: 이벤트 공지
  - 제목: 🐾 펫GPT 여름맞이 '댕냥이 건강 상담' 이벤트!
  - 내용: 펫GPT에서 여름철 반려동물 건강 관리를 위한 특별 이벤트를 준비했습니다! 전문 수의사와의 1:1 온라인 건강 상담 기회를 놓치지 마세요. 신청은 펫GPT 공지사항 게시판에서 가능합니다.
  - 이미지: /img/product/cat_prescription.jpeg
  - 조회수: (DML 기준 RAND() \* 900) + 120
  - 좋아요 수: 0 (초기값)
  - 댓글 수: 0 (초기값)
  - 등록일: (DML 기준 NOW() - INTERVAL FLOOR(RAND()\*5) DAY - INTERVAL 4 HOUR)

- **게시글 ID: 11** (DML의 열한 번째 communityboard INSERT)

  - 작성자 ID: admin1
  - 관련 상품 ID: (없음, 시스템 공지, 내용은 상품 ID 191 이미지 사용)
  - 카테고리: 시스템 공지
  - 제목: 📢 펫GPT 포인트 적립 정책 변경 사전 안내 (8월 1일부터 적용)
  - 내용: 안녕하세요, 펫GPT입니다. 고객님들께 더 나은 혜택을 제공하고자 8월 1일부터 포인트 적립 정책이 일부 변경될 예정입니다. 자세한 내용은 공지사항 게시판 및 앱 내 알림을 확인해주시기 바랍니다. 항상 펫GPT를 이용해주셔서 감사합니다.
  - 이미지: /img/product/cat_tower_wood.jpg
  - 조회수: (DML 기준 RAND() \* 800) + 100
  - 좋아요 수: 0 (초기값)
  - 댓글 수: 0 (초기값)
  - 등록일: (DML 기준 NOW() - INTERVAL FLOOR(RAND()\*3) DAY - INTERVAL 11 HOUR)

- **게시글 ID: 14** (DML의 열네 번째 communityboard INSERT)
  - 작성자 ID: admin2
  - 관련 상품 ID: (없음, 이벤트 공지, 내용은 상품 ID 140 이미지 사용)
  - 카테고리: 이벤트 공지
  - 제목: 🐾 펫GPT와 함께하는 유기동물 후원 캠페인 안내
  - 내용: 펫GPT는 도움이 필요한 유기동물들을 위해 새로운 후원 캠페인을 시작합니다. 고객님들의 따뜻한 관심과 참여가 작은 생명들에게 큰 힘이 됩니다. 자세한 참여 방법은 펫GPT 앱 이벤트 페이지를 확인해주세요.
  - 이미지: /img/product/dog_organic.jpeg
  - 조회수: (DML 기준 RAND() \* 750) + 90
  - 좋아요 수: 0 (초기값)
  - 댓글 수: 0 (초기값)
  - 등록일: (DML 기준 NOW() - INTERVAL FLOOR(RAND()\*5) DAY - INTERVAL 14 HOUR)

_(참고: 상품 정보 파트에서 이미 언급된 상품 연관 커뮤니티 게시글들은 해당 상품 섹션에 포함되어 있습니다. 위 목록은 주로 관리자 공지/이벤트성 게시글입니다.)_

---

# 커뮤니티 게시글 좋아요 (Post Likes Table - 일부 예시)

- 게시글 ID 1 (시스템 공지) 좋아요: dogfan02, mintycat
- 게시글 ID 2 (catlover01의 후드티 자랑) 좋아요: puppyboom, catboss
- 게시글 ID 3 (dogleader의 원목하우스 자랑) 좋아요: catlover01

---

# 커뮤니티 댓글 좋아요 (Comment Likes Table - 일부 예시)

- 게시글 ID 1의 댓글 ID 1 (catlover01 작성) 좋아요: dogleader
- 게시글 ID 1의 댓글 ID 2 (dogleader 작성) 좋아요: catlover01
- 게시글 ID 2의 댓글 ID 4 (mintycat 작성) 좋아요: puppyboom

---
