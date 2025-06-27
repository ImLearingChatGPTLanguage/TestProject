package com.mycompany.foodorderingsystem.service;

import com.mycompany.foodorderingsystem.model.User;
import com.mycompany.foodorderingsystem.repository.OrderRepository;
import com.mycompany.foodorderingsystem.repository.UserRepository;
import java.sql.Timestamp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Override
    public User registerUser(User user) throws Exception {
        if (userRepository.findByUsername(user.getUsername()).isPresent()) {
            throw new Exception("Tên đăng nhập '" + user.getUsername() + "' đã được sử dụng.");
        }
        if (userRepository.findByEmail(user.getEmail()).isPresent()) {
            throw new Exception("Email '" + user.getEmail() + "' đã được đăng ký.");
        }
        if (user.getRole() == null || user.getRole().trim().isEmpty()) {
            user.setRole("CUSTOMER");
        }
        user.setActive(true);
        return userRepository.save(user);
    }

    @Override
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    public Optional<User> findUserById(Long userId) {
        return userRepository.findById(userId);
    }

    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public User updateUserByAdmin(User userToUpdate) throws Exception {
        User existingUser = userRepository.findById(userToUpdate.getUserId())
                .orElseThrow(() -> new Exception("Không tìm thấy người dùng với ID: " + userToUpdate.getUserId()));

        if (userToUpdate.getEmail() != null && !userToUpdate.getEmail().equalsIgnoreCase(existingUser.getEmail())) {
            Optional<User> userByNewEmail = userRepository.findByEmail(userToUpdate.getEmail());
            if (userByNewEmail.isPresent() && !userByNewEmail.get().getUserId().equals(userToUpdate.getUserId())) {
                throw new Exception("Email " + userToUpdate.getEmail() + " đã được sử dụng bởi một người dùng khác.");
            }
            existingUser.setEmail(userToUpdate.getEmail());
        }
        existingUser.setFullName(userToUpdate.getFullName());
        existingUser.setPhoneNumber(userToUpdate.getPhoneNumber());
        existingUser.setRole(userToUpdate.getRole());
        existingUser.setActive(userToUpdate.isActive());
        return userRepository.save(existingUser);
    }

    @Override
    public User updateCustomerProfile(User userFromForm, Long currentUserId) throws Exception {
        User existingUser = userRepository.findById(currentUserId)
                .orElseThrow(() -> new Exception("User không tồn tại với ID: " + currentUserId));
        if (userFromForm.getEmail() != null && !userFromForm.getEmail().equalsIgnoreCase(existingUser.getEmail())) {
            Optional<User> userByNewEmail = userRepository.findByEmail(userFromForm.getEmail());
            if (userByNewEmail.isPresent()) {
                throw new Exception("Email " + userFromForm.getEmail() + " đã được sử dụng bởi một tài khoản khác.");
            }
            existingUser.setEmail(userFromForm.getEmail());
        }
        existingUser.setFullName(userFromForm.getFullName());
        existingUser.setPhoneNumber(userFromForm.getPhoneNumber());
        return userRepository.save(existingUser);
    }

    @Override
    public boolean deactivateUser(Long userId) throws Exception {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new Exception("Không tìm thấy người dùng với ID: " + userId));
        user.setActive(false);
        userRepository.save(user);
        return true;
    }

    @Override
    public boolean activateUser(Long userId) throws Exception {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new Exception("Không tìm thấy người dùng với ID: " + userId));
        user.setActive(true);
        userRepository.save(user);
        return true;
    }

    @Override
    public boolean deleteUserPermanently(Long userId) throws Exception {
        if (!userRepository.existsById(userId)) {
            throw new Exception("Không tìm thấy người dùng với ID: " + userId);
        }
        if (!orderRepository.findByCustomerUser_UserId(userId).isEmpty()) {
            throw new Exception("Không thể xóa người dùng này vì họ đã có lịch sử đặt hàng. Vui lòng sử dụng chức năng 'Vô hiệu hóa'.");
        }
        userRepository.deleteById(userId);
        return true;
    }

    @Override
    public List<User> searchUsersByNameForAdmin(String nameKeyword) {
        if (nameKeyword == null || nameKeyword.trim().isEmpty()) {
            return userRepository.findAll();
        }
        return userRepository.searchUsers(nameKeyword.trim());
    }

    @Override
    public void changeUserPassword(User user, String currentPassword, String newPassword) throws Exception {
        if (!user.getPassword().equals(currentPassword)) {
            throw new Exception("Mật khẩu hiện tại không chính xác.");
        }
        user.setPassword(newPassword);
        userRepository.save(user);
    }

    @Override
    public void createPasswordResetTokenForUser(String email) throws Exception {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new Exception("Không tìm thấy tài khoản nào với email: " + email));

        String token = UUID.randomUUID().toString();
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.HOUR, 1);
        Date expiryDate = cal.getTime();

        user.setPasswordResetToken(token);
        user.setTokenExpiryDate(expiryDate);
        userRepository.save(user);
    }

    @Override
    public User validatePasswordResetToken(String token) {
        return userRepository.findByPasswordResetToken(token)
                .filter(user -> user.getTokenExpiryDate().after(new Date()))
                .orElse(null);
    }

    @Override
    public void changeUserPassword(String token, String newPassword) throws Exception {
        User user = validatePasswordResetToken(token);
        if (user == null) {
            throw new Exception("Token không hợp lệ hoặc đã hết hạn.");
        }
        user.setPassword(newPassword);
        user.setPasswordResetToken(null);
        user.setTokenExpiryDate(null);
        userRepository.save(user);
    }

    @Override
    public long getTotalUserCount() {
        return userRepository.count();
    }

    @Override
    public long getNewUserCountForPeriod(Timestamp startDate, Timestamp endDate) {
        return userRepository.countByCreatedAtBetween(startDate, endDate);
    }

    @Override
    @Transactional
    public void adminSetUserPassword(Long userId, String newPassword) throws Exception {
        if (newPassword == null || newPassword.trim().isEmpty() || newPassword.length() < 6) {
            throw new Exception("Mật khẩu mới phải có ít nhất 6 ký tự.");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new Exception("Không tìm thấy người dùng với ID: " + userId));

        user.setPassword(newPassword);

        userRepository.save(user);
    }
}
