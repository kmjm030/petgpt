
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Map Begin -->
<div class="map">
    <%-- 지도 src는 실제 위치로 변경 또는 API 사용 필요 --%>
<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d111551.9926412813!2d-90.27317134641879!3d38.606612219170856!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x54eab584e432360b%3A0x1c3bb99243deb742!2sUnited%20States!5e0!3m2!1sen!2sbd!4v1597926938024!5m2!1sen!2sbd" height="500" style="border:0;" allowfullscreen="" aria-hidden="false" tabindex="0"></iframe>
</div>
<!-- Map End -->

<!-- Contact Section Begin -->
<section class="contact spad">
  <div class="container">
    <div class="row">
      <div class="col-lg-6 col-md-6">
        <div class="contact__text">
          <div class="section-title">
            <span>Information</span>
            <h2>Contact Us</h2>
            <p>As you might expect of a company that began as a high-end interiors contractor, we pay
              strict attention.</p>
          </div>
          <ul>
            <%-- 연락처 정보는 실제 정보로 변경 필요 --%>
            <li>
              <h4>America</h4>
              <p>195 E Parker Square Dr, Parker, CO 801 <br />+43 982-314-0958</p>
            </li>
            <li>
              <h4>France</h4>
              <p>109 Avenue Léon, 63 Clermont-Ferrand <br />+12 345-423-9893</p>
            </li>
          </ul>
        </div>
      </div>
      <div class="col-lg-6 col-md-6">
        <div class="contact__form">
          <%-- 문의 보내기 기능 필요 --%>
          <form action="#">
            <div class="row">
              <div class="col-lg-6">
                <input type="text" placeholder="Name" name="contactName" required>
              </div>
              <div class="col-lg-6">
                <input type="email" placeholder="Email" name="contactEmail" required> <%-- type="email" --%>
              </div>
              <div class="col-lg-12">
                <textarea placeholder="Message" name="contactMessage" required></textarea>
                <button type="submit" class="site-btn">Send Message</button>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</section>
<!-- Contact Section End -->