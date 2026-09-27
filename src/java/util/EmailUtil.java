package util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.Random;

public class EmailUtil {

    // Cấu hình tài khoản gửi Gmail chính thức với App Password
    private static final String FROM_EMAIL = "email@gmail.com";
    private static final String APP_PASSWORD = "nhap vao day"; // Mật khẩu ứng dụng 16 ký tự Google 

    /**
     * Sinh mã OTP ngẫu nhiên gồm 6 chữ số (từ 100000 đến 999999)
     */
    public static String generateOtp() {
        Random rnd = new Random();
        int number = 100000 + rnd.nextInt(900000);
        return String.valueOf(number);
    }

    /**
     * Gửi email chứa mã OTP xác thực đặt lại mật khẩu
     * @param toEmail Email người nhận
     * @param username Tên đăng nhập của tài khoản
     * @param otp Mã OTP 6 chữ số
     * @return true nếu gửi thành công qua SMTP hoặc log thành công
     */
    public static boolean sendOtpEmail(String toEmail, String username, String otp) {
        System.out.println("=================================================================");
        System.out.println(" [HanziGo OTP LOG] Gửi tới: " + toEmail + " | Tài khoản: " + username + " | MÃ OTP: " + otp);
        System.out.println("=================================================================");

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "HanziGo Chinese Learning", "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("[HanziGo] Mã xác thực OTP đặt lại mật khẩu của bạn", "UTF-8");

            // HTML Email Template phong cách HanziGo với meta charset UTF-8
            String htmlContent = "<!DOCTYPE html><html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /></head><body>"
                    + "<div style=\"max-width: 580px; margin: 0 auto; font-family: 'Segoe UI', Arial, sans-serif; background: #faf7f2; border: 1px solid #e4ded5; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05);\">"
                    + "<div style=\"background: #eb4e2b; padding: 24px; text-align: center; color: #ffffff;\">"
                    + "<h1 style=\"margin: 0; font-size: 26px; font-weight: 800; letter-spacing: 1px;\">汉 HanziGo</h1>"
                    + "<p style=\"margin: 6px 0 0 0; font-size: 13px; opacity: 0.9;\">Hệ Thống Học Từ Vựng HSK Thông Minh</p>"
                    + "</div>"
                    + "<div style=\"padding: 30px 25px; background: #ffffff;\">"
                    + "<h2 style=\"color: #2b2625; font-size: 18px; margin-top: 0;\">Xin chào <b>" + (username != null ? username : "Học viên") + "</b>,</h2>"
                    + "<p style=\"color: #555555; line-height: 1.6; font-size: 14px;\">Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản liên kết với địa chỉ email này trên HanziGo.</p>"
                    + "<p style=\"color: #555555; line-height: 1.6; font-size: 14px;\">Dưới đây là mã xác thực <b>OTP</b> của bạn:</p>"
                    + "<div style=\"text-align: center; margin: 25px 0;\">"
                    + "<span style=\"display: inline-block; font-size: 32px; font-weight: 800; letter-spacing: 6px; color: #eb4e2b; background: #fff5f2; border: 2px dashed #eb4e2b; border-radius: 8px; padding: 12px 30px;\">"
                    + otp
                    + "</span>"
                    + "</div>"
                    + "<p style=\"color: #e65100; font-size: 13px; font-weight: 600; text-align: center;\">⏱️ Mã OTP này có hiệu lực trong vòng <b>5 phút</b>.</p>"
                    + "<hr style=\"border: none; border-top: 1px solid #f0ece6; margin: 25px 0;\" />"
                    + "<p style=\"color: #888888; font-size: 12px; line-height: 1.5; margin-bottom: 0;\">Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email. Mật khẩu của bạn vẫn an toàn và không bị thay đổi.</p>"
                    + "</div>"
                    + "<div style=\"background: #faf7f2; padding: 16px; text-align: center; font-size: 12px; color: #888888; border-top: 1px solid #e4ded5;\">"
                    + "HanziGo · 每天一点点 — mỗi ngày một chút"
                    + "</div>"
                    + "</div>"
                    + "</body></html>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("✅ [HanziGo] Gửi email OTP qua Gmail thành công tới: " + toEmail);
            return true;
        } catch (MessagingException | java.io.UnsupportedEncodingException e) {
            System.err.println("⚠️ [HanziGo] Lỗi gửi email qua SMTP: " + e.getMessage());
            System.err.println("ℹ️ [HanziGo] Gợi ý: Nếu dùng tài khoản Gmail có xác thực 2 bước, hãy tạo Mật khẩu ứng dụng (App Password 16 ký tự) và điền vào EmailUtil.java.");
            // Vẫn trả về true hoặc cho phép luồng tiếp tục với OTP đã in ở console để người dùng không bị nghẽn
            return false;
        }
    }
}
