package com.mycompany.foodorderingsystem.service;

import com.mycompany.foodorderingsystem.model.Address;
import java.util.Optional;

public interface AddressService {

    Address saveAddress(Address address);

    Optional<Address> findAddressById(Long addressId);

    Address updateAddress(Address address) throws Exception;

    void deleteAddress(Long addressId) throws Exception;
}
