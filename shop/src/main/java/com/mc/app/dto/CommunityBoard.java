package com.mc.app.dto;

import java.time.LocalDateTime;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CommunityBoard {

    private Integer boardKey;
    private String custId;
    private Integer itemKey;
    private String category;
    private String boardTitle;
    private String boardContent;
    private String boardImg;
    private LocalDateTime regDate;
    private LocalDateTime updateDate;
    
    private Integer viewCount;
    private Integer likeCount;
    private Integer commentCount;

    // JSON 직렬화를 위한 추가 getter 메서드
    @JsonProperty("postId")
    public Integer getPostId() {
        return boardKey;
    }

    @JsonProperty("title")
    public String getJsonTitle() {
        return boardTitle;
    }

    @JsonProperty("content")
    public String getJsonContent() {
        return boardContent;
    }

    @JsonProperty("image")
    public String getImage() {
        return boardImg;
    }

    @JsonProperty("authorName")
    public String getAuthorName() {
        return custId;
    }

    @JsonProperty("createdAt")
    public LocalDateTime getCreatedAt() {
        return regDate;
    }

    public Integer getBoardId() {
        return boardKey;
    }

    public String getTitle() {
        return boardTitle;
    }

    // 여러 개의 이미지를 저장할 수 있도록 String[] 배열로 반환
    public String[] getImages() {
        return boardImg != null ? new String[] { boardImg } : new String[0];
    }

    public void onCreate() {
        regDate = LocalDateTime.now();
        updateDate = LocalDateTime.now();
    }

    public void onUpdate() {
        updateDate = LocalDateTime.now();
    }

    public void increaseViewCount() {
        this.viewCount = (this.viewCount == null) ? 1 : this.viewCount + 1;
    }

    public void increaseLikeCount() {
        this.likeCount = (this.likeCount == null) ? 1 : this.likeCount + 1;
    }

    public void decreaseLikeCount() {
        if (this.likeCount != null && this.likeCount > 0) {
            this.likeCount--;
        }
    }

    public void increaseCommentCount() {
        this.commentCount = (this.commentCount == null) ? 1 : this.commentCount + 1;
    }

    public void decreaseCommentCount() {
        if (this.commentCount != null && this.commentCount > 0) {
            this.commentCount--;
        }
    }


    @JsonProperty("summary")
    public String getSummary() {
        if (boardContent == null || boardContent.isEmpty()) {
            return "";
        }
        int maxLength = 100;
        return boardContent.length() > maxLength ? boardContent.substring(0, maxLength) + "..." : boardContent;
    }
}
