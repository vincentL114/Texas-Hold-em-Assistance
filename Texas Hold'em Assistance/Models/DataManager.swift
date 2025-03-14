//
//  DataManager.swift
//  Texas Hold'em Assistance
//
//  Created by Vincent on 3/7/25.
//
import Foundation

/// DataManager provides functionality to load, save, update, and delete game records stored in UserDefaults.
public class DataManager{
    
    /// Shared instance of DataManager for global access.
    public static let sharedInstance = DataManager()
    
    /// This prevents others from using the default '()' initializer
    fileprivate init() {}
    
    /// Loads game records from UserDefaults.
    func loadGameRecords() -> [GameRecord] {
        guard let data = UserDefaults.standard.data(forKey: "gameRecords") else {
            return []
        }
        
        let decoder = JSONDecoder()
        do {
            let records = try decoder.decode([GameRecord].self, from: data)
            print("Game records loaded successfully. Total records: \(records.count)")
            return records
        } catch {
            print("Error decoding game records: \(error)")
            return []
        }
    }
    
    /// Saves a new game record to UserDefaults by appending it to the existing records.
    func saveGameRecords(newRecord: GameRecord) {
        var records = loadGameRecords()
        
        // Append the new game record to the records array.
        records.append(newRecord)
        
        let encoder = JSONEncoder()
       
        do {
            let data = try encoder.encode(records)
            UserDefaults.standard.set(data, forKey: "gameRecords")
            print("Saved game record successfully.")
        } catch {
            print("Failed to save game records: \(error)")
        }
    }
    
    /// Updates an existing game record in UserDefaults.
    func updateGameRecord(updatedRecord: GameRecord) {
        var records = loadGameRecords()
        // Find the index of the record to update.
        if let index = records.firstIndex(where: { $0.id == updatedRecord.id }) {
            // Update the record at that index.
            records[index] = updatedRecord
            
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(records)
                UserDefaults.standard.set(data, forKey: "gameRecords")
                print("Game record updated successfully.")
            } catch {
                print("Failed to update game record: \(error)")
            }
        } else {
            print("Record not found for update.")
        }
    }

    /// Deletes game records at the specified offsets from UserDefaults.
    func deleteGameRecords(at offsets: IndexSet) {
        var records = loadGameRecords()
        
        // Remove records at the provided offsets.
        records.remove(atOffsets: offsets)
        
        // Save the updated records array back to UserDefaults.
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(records)
            UserDefaults.standard.set(data, forKey: "gameRecords")
            print("Game record deleted successfully.")
        } catch {
            print("Failed to delete game records: \(error)")
        }
    }
    
    /// Moves  game records  based on the user's drag-and-drop actions.
    func moveGameRecords(from source: IndexSet, to destination: Int) {
        var records = loadGameRecords()
        // Reorder the records array.
        records.move(fromOffsets: source, toOffset: destination)
        
        let encoder = JSONEncoder()
        do {
            // Encode the updated records.
            let data = try encoder.encode(records)
            // Save the updated records to UserDefaults.
            UserDefaults.standard.set(data, forKey: "gameRecords")
            print("Game records moved successfully.")
        } catch {
            print("Failed to move game records: \(error)")
        }
    }
    
}

