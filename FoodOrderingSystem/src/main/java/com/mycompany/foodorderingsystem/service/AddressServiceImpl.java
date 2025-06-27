package com.mycompany.foodorderingsystem.service;

import com.mycompany.foodorderingsystem.model.Address;
import com.mycompany.foodorderingsystem.repository.AddressRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Transactional
public class AddressServiceImpl implements AddressService {

    @Autowired
    private AddressRepository addressRepository;

    @Override
    public Address saveAddress(Address address) {
        return addressRepository.save(address);
    }

    @Override
    public Optional<Address> findAddressById(Long addressId) {
        return addressRepository.findById(addressId);
    }

    @Override
    public Address updateAddress(Address address) throws Exception {
        if (address.getAddressId() == null) {
            throw new Exception("Address ID must not be null for an update.");
        }

        addressRepository.findById(address.getAddressId())
                .orElseThrow(() -> new Exception("Address not found with ID: " + address.getAddressId() + " for update."));

        return addressRepository.save(address);
    }

    @Override
    public void deleteAddress(Long addressId) throws Exception {
        addressRepository.findById(addressId)
                .orElseThrow(() -> new Exception("Address not found with ID: " + addressId + " for deletion."));

        addressRepository.deleteById(addressId);
    }
}
