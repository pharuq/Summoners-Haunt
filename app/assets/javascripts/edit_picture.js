$(document).on('turbolinks:load', function() {
  // var $image = $('#crop_area_box > img'),replaced;
  $(".input_picture").change(function(){
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert('ファイルサイズが大きいです。5MB以下の画像を選択してください。');
      $(".submit").prop('disabled', true);
    } else if (this.files.length > 3) {
      alert('ファイルは３つまでにしてください。');
      $(".submit").prop('disabled', true);
    } else {
      $(".submit").prop('disabled', false);
    }

    $('#crop_image').removeClass('hidden');
    readURL(this);
  });

  // getDataボタンが押された時の処理
  $('.submit').on('click', function(){
     // crop のデータを取得
     var data = $('#crop_image').cropper('getData');

     $('#image_w').val(Math.round(data.width));
     $('#image_h').val(Math.round(data.height));
     $('#image_x').val(Math.round(data.x));
     $('#image_y').val(Math.round(data.y));
  });

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        $('#crop_image').attr('src', e.target.result);
        $('#crop_image').cropper("destroy");
        $('#crop_image').cropper({
          aspectRatio: 4 / 4
        });
      }
      reader.readAsDataURL(input.files[0]);
    }
  }
});
