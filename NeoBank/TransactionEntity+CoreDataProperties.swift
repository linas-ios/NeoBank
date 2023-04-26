//
//  TransactionEntity+CoreDataProperties.swift
//  NeoBank
//
//  Created by Linas Nutautas on 25/04/2023.
//
//

import Foundation
import CoreData


extension TransactionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }

    @NSManaged public var sendingAccountId: Int64
    @NSManaged public var receivingAccountId: Int64
    @NSManaged public var receiverPhoneNumber: String?
    @NSManaged public var comment: String?
    @NSManaged public var amount: Double
    @NSManaged public var transactionTime: Double

}

extension TransactionEntity : Identifiable {

}
