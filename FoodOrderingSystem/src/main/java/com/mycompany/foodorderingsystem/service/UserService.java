package com.mycompany.foodorderingsystem.service;

import com.mycompany.foodorderingsystem.model.User;
import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

public interface UserService {

    User registerUser(User user) throws Exception;

    Optional<User> findByUsername(String username);

    Optional<User> findUserById(Long userId);

    List<User> getAllUsers();

    User updateUserByAdmin(User user) throws Exception;

    User updateCustomerProfile(User userFromForm, Long currentUserId) throws Exception;

    boolean deactivateUser(Long userId) throws Exception;

    boolean activateUser(Long userId) throws Exception;

    boolean deleteUserPermanently(Long userId) throws Exception;

    List<User> searchUsersByNameForAdmin(String nameKeyword);

    void changeUserPassword(User user, String currentPassword, String newPassword) throws Exception;

    void createPasswordResetTokenForUser(String email) throws Exception;

    User validatePasswordResetToken(String token);

    void changeUserPassword(String token, String newPassword) throws Exception;

    long getTotalUserCount();

    long getNewUserCountForPeriod(Timestamp startDate, Timestamp endDate);

    void adminSetUserPassword(Long userId, String newPassword) throws Exception;
}
