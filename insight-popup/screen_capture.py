from PIL import ImageGrab
import io


def capture_screen_to_bytes():
    """화면 전체를 캡쳐하여 Bytes 형태로 반환합니다."""
    try:
        print("화면 캡쳐 시도...")
        img = ImageGrab.grab()
        img_byte_arr = io.BytesIO()
        img.save(img_byte_arr, format="PNG")  # 또는 JPEG
        img_byte_arr = img_byte_arr.getvalue()
        print("화면 캡쳐 성공")
        return img_byte_arr
    except Exception as e:
        print(f"화면 캡쳐 오류: {e}")
        return None
