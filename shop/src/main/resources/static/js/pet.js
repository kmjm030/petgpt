function openModal() {
    document.getElementById("petModal").style.display = "block";
    pet.info();
}

function closeModal() {
    document.getElementById("petModal").style.display = "none";
}

const pet = {
    contextPath: '',       // contextPath 저장 변수 추가
    defaultProfileImg: '',

    init: function () {
        const petData = $('#pet-data');
        this.contextPath = petData.data('context-path') || '';
        this.defaultProfileImg = petData.data('default-profile-img') || '';
        console.log("Pet JS initialized. Context Path:", this.contextPath, "Default Img:", this.defaultProfileImg);

        $('#uploadFile').change(function (e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    $('#profile-img').attr('src', e.target.result);  // 이미지 미리보기 변경
                };
                reader.readAsDataURL(file);
            }
        });

        $('#modal_pet_add_btn').click(() => {
            this.check();
        });
    },

    info: function () {
        $('#petName').on('input', function () {
            const name = $(this).val();
            $('#modal-pet-name').text(name || '');
        });
        $('#petType').on('change', function () {
            let type = $(this).val();
            if (type == 'dog') {
                type = "🐶"
            } else if (type == 'cat') {
                type = "🐱"
            }
            $('#modal-pet-type').text(type);
        });
        $('#petGender').on('change', function () {
            let type = $(this).val();
            if (type == 'M') {
                type = "남자"
            } else if (type == 'F') {
                type = "여자"
            }
            $('#modal-pet-gender').text('▪ 성별: ' + type);
        });
        $('#petBreed').on('input', function () {
            const breed = $(this).val();
            $('#modal-pet-breed').text('▪ 종: ' + breed || '');
        });
        $('#petGender').on('input', function () {
            let gender = $(this).val();
            if (gender == 'F') {
                gender = "여자"
            } else if (gender == 'M') {
                gender = "남자"
            }
            $('#modal-pet-gender').text('▪ 성별: ' + gender || '');
        });

        $('#petBirthdate').on('input', function () {
            const birth = $(this).val();
            if (birth) {
                $('#modal-pet-birthdate').text('▪ 생년월일: ' + birth);
            } else {
                $('#modal-pet-birthdate').text('▪ 생년월일: ');
            }
        });
    },

    check: function () {
        let name = $('#petName').val();
        let type = $('#petType').val();
        let gender = $('#petGender').val();
        let birth = $('#petBirthdate').val();
        let breed = $('#petBreed').val();
        let imgFile = $('#uploadFile')[0].files[0];

        $('#msg').text('');

        if (!imgFile) {
            $('#msg').text('❗ 반려동물의 사진을 등록해주세요.');
            return;
        }
        if (name == '' || name == null) {
            $('#msg').text('❗ 반려동물의 이름을 입력해주세요.');
            $('#petName').focus();
            return;
        }
        if (type == '' || type == null) {
            $('#msg').text('❗ 강아지인가요, 고양이인가요? 선택해주세요!');
            $('#petType').focus();
            return;
        }
        if (gender == '' || gender == null) {
            $('#msg').text('❗ 성별을 입력해주세요.');
            $('#petGender').focus();
            return;
        }
        if (breed == '' || breed == null) {
            $('#msg').text('❗ 종을 입력해주세요.');
            $('#petBreed').focus();
            return;
        }
        if (!birth) {
            $('#msg').text('❗ 생일을 입력해주세요.');
            $('#petBirthdate').focus();
            return;
        }
        this.send();
    },

    submitForm: function () {
        document.getElementById('pet_update_form').submit();
    },

    send: function () {
        $('#pet_add_form').attr('method', 'post');
        $('#pet_add_form').attr('action', this.contextPath + '/pet/addimpl');
        $('#pet_add_form').submit();
    },

    del: function (petKey) {
        console.log("Deleting pet with key:", petKey);
        let c = confirm('삭제하시겠습니까?');
        if (c == true) {
            location.href = this.contextPath + '/pet/delimpl?petKey=' + petKey;
        }
    }
}

let currentPetIndex = 0;
let petNames = [];
let recommendedItemsMap = {};

function loadRecommendations() {
  const custId = $('#custId').val();
  const contextPath = $('#contextPath').val();

  console.log("불러온 custId:", custId)

  $.ajax({
    url: contextPath + '/recommenditem',
    method: 'GET',
    data: { id: custId },
    success: function (data) {
      console.log("추천 데이터:", data);
      recommendedItemsMap = data;
      petNames = Object.keys(data);
      if (petNames.length > 0) {
        showRecommendation();
        setInterval(showRecommendation, 10000);
      }
    },
    error: function () {
      console.error("추천 상품을 불러오지 못했어요 😢");
    }
  });
}

function showRecommendation() {
  const petName = petNames[currentPetIndex];
  const items = recommendedItemsMap[petName];

  const container = $('#product-box');

  container.fadeOut(300, function () {
    let html = `
      <h4 style="text-align:center; font-family:'NEXON Lv1 Gothic OTF'"><strong>이런 상품 어때요?</strong></h4>
      <h6 style="text-align:center; margin-top:10px;">반려동물 <strong>${petName}</strong>를 위해 펫지피티가 추천하는 상품 5가지!✨</h6>
      <div class="row justify-content-center">
      <div class="scroll-wrapper">
    `;

    for (let item of items) {
      html += `
        <div class="col-md-2">
          <div class="item-box">
            <a href="/shop/details?itemKey=${item.itemKey}">
            <img class="fade-target img-fluid" src="${contextPath}/img/product/${item.itemImg1}" style="display:none;"/></a>
            <p class="fade-target" style="display:none; text-align:center;">${item.itemName}</p>
          </div>
        </div>
      `;
    }

    html += '</div></div>';

    container.html(html).fadeIn(300, function () {
      // 이미지랑 텍스트만 따로 페이드 인
      $('.fade-target').each(function (i, el) {
        $(el).delay(100 * i).fadeIn(400); // 하나씩 살짝 딜레이 주면 귀여움 UP!
      });
    });
  });

  currentPetIndex = (currentPetIndex + 1) % petNames.length;
}
$(function () {
    pet.init();
    loadRecommendations();
});
