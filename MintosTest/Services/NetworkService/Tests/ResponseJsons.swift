//
//  ResponseJsons.swift
//  MintosTest
//
//  Created by Maksim Polous on 02/09/2023.
//

let fullResponseJson = """
    {
      "response": {
        "paymentDetails": "Investor ID: 54361338",
        "items": [
          {
            "bank": "Acme Bank",
            "swift": "ACMEUS33",
            "currency": "EUR",
            "beneficiaryName": "AS Mintos Marketplace",
            "beneficiaryBankAddress": "10 Rue de la Paix, 75002 Paris, France",
            "iban": "GB29NWBK60161331926819"
          },
          {
            "bank": "City Bank",
            "swift": "CITIUS33",
            "currency": "USD",
            "beneficiaryName": "AS Mintos Marketplace",
            "beneficiaryBankAddress": "123 Main Street, New York, NY, USA",
            "iban": "US12345678901234567890"
          },
          {
            "bank": "EuroBank Poland",
            "swift": "EURBPLPW",
            "currency": "PLN",
            "beneficiaryName": "AS Mintos Marketplace",
            "beneficiaryBankAddress": "567 Maple Avenue, Warsaw, Poland",
            "iban": "PL87654321098765432109"
          }
        ]
      }
    }
"""

let partialResponseJson = """
    {
      "response": {
        "items": [
          {
            "swift": "ACMEUS33",
          },
          {
            "bank": "City Bank",
          },
          {
            "beneficiaryName": "AS Mintos Marketplace",
          }
        ]
      }
    }
"""
