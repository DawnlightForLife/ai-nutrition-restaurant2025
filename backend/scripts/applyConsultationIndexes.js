#!/usr/bin/env node

/**
 * Script to apply consultation indexes for performance optimization
 * Run this script to fix the consultation API timeout issues
 * 
 * Usage: node scripts/applyConsultationIndexes.js
 */

require('dotenv').config();
const mongoose = require('mongoose');
const { applyConsultationIndexes } = require('../models/consult/consultationModel_indexes');
const config = require('../config');
const logger = require('../config/modules/logger');

async function main() {
  try {
    // Connect to MongoDB
    console.log('Connecting to MongoDB...');
    const mongoUri = config.database?.uri || process.env.MONGODB_URI || 'mongodb://localhost:27017/ai_nutrition_db';
    await mongoose.connect(mongoUri);
    console.log('✓ Connected to MongoDB');

    // Get the Consultation model
    const Consultation = require('../models/consult/consultationModel');
    
    // Apply indexes
    await applyConsultationIndexes(Consultation);
    
    // Analyze collection statistics
    console.log('\nAnalyzing collection statistics...');
    const stats = await Consultation.collection.stats();
    console.log(`Collection size: ${(stats.size / 1024 / 1024).toFixed(2)} MB`);
    console.log(`Document count: ${stats.count}`);
    console.log(`Average document size: ${(stats.avgObjSize / 1024).toFixed(2)} KB`);
    
    // Test query performance
    console.log('\nTesting query performance...');
    
    // Test 1: Market consultations query
    const start1 = Date.now();
    const marketConsultations = await Consultation.find({
      isMarketOpen: true,
      status: 'available'
    })
    .sort({ priority: -1, marketPublishedAt: -1 })
    .limit(20)
    .lean();
    const time1 = Date.now() - start1;
    console.log(`✓ Market consultations query: ${time1}ms (${marketConsultations.length} results)`);
    
    // Test 2: Nutritionist consultations query
    const start2 = Date.now();
    const nutritionistConsultations = await Consultation.find({
      nutritionistId: new mongoose.Types.ObjectId()
    })
    .sort({ createdAt: -1 })
    .limit(20)
    .lean();
    const time2 = Date.now() - start2;
    console.log(`✓ Nutritionist consultations query: ${time2}ms`);
    
    // Test 3: Text search query
    const start3 = Date.now();
    const searchResults = await Consultation.find({
      $text: { $search: '减肥' }
    })
    .limit(10)
    .lean();
    const time3 = Date.now() - start3;
    console.log(`✓ Text search query: ${time3}ms (${searchResults.length} results)`);
    
    console.log('\n✅ Index optimization completed successfully!');
    console.log('The consultation API performance should be significantly improved.');
    
  } catch (error) {
    console.error('❌ Error applying indexes:', error);
    process.exit(1);
  } finally {
    await mongoose.connection.close();
    console.log('\nDatabase connection closed.');
  }
}

// Run the script
main().catch(console.error);