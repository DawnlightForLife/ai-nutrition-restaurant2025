/**
 * Consultation Model Index Optimization Script
 * This script adds missing indexes to improve query performance
 * Run this script to optimize consultation API response times
 */

const mongoose = require('mongoose');

// Index optimization for consultation queries
const consultationIndexes = [
  // Performance-critical indexes for market queries
  {
    index: { isMarketOpen: 1, status: 1, marketPublishedAt: -1, priority: -1 },
    options: { 
      name: 'market_priority_idx',
      background: true,
      partialFilterExpression: { isMarketOpen: true }
    }
  },
  
  // Compound index for nutritionist consultation queries
  {
    index: { nutritionistId: 1, status: 1, createdAt: -1 },
    options: { 
      name: 'nutritionist_status_idx',
      background: true 
    }
  },
  
  // Index for user consultation history
  {
    index: { userId: 1, status: 1, createdAt: -1 },
    options: { 
      name: 'user_status_idx',
      background: true 
    }
  },
  
  // Index for upcoming consultations
  {
    index: { status: 1, scheduledTime: 1, nutritionistId: 1 },
    options: { 
      name: 'upcoming_consultations_idx',
      background: true,
      partialFilterExpression: { 
        status: { $in: ['scheduled', 'pending'] },
        scheduledTime: { $exists: true }
      }
    }
  },
  
  // Index for consultation search by tags
  {
    index: { tags: 1, isMarketOpen: 1, status: 1 },
    options: { 
      name: 'tags_market_idx',
      background: true,
      sparse: true
    }
  },
  
  // Index for budget range queries
  {
    index: { budget: 1, isMarketOpen: 1, status: 1 },
    options: { 
      name: 'budget_market_idx',
      background: true,
      sparse: true
    }
  },
  
  // Text index for full-text search
  {
    index: { topic: 'text', description: 'text' },
    options: { 
      name: 'consultation_text_idx',
      background: true,
      weights: {
        topic: 10,
        description: 5
      }
    }
  }
];

/**
 * Apply indexes to the Consultation collection
 * This function should be called during database initialization
 */
async function applyConsultationIndexes(ConsultationModel) {
  try {
    console.log('Starting consultation index optimization...');
    
    for (const indexDef of consultationIndexes) {
      try {
        await ConsultationModel.collection.createIndex(indexDef.index, indexDef.options);
        console.log(`✓ Created index: ${indexDef.options.name}`);
      } catch (error) {
        if (error.code === 11000 || error.code === 85) {
          console.log(`- Index already exists: ${indexDef.options.name}`);
        } else {
          console.error(`✗ Failed to create index ${indexDef.options.name}:`, error.message);
        }
      }
    }
    
    // List all indexes
    const indexes = await ConsultationModel.collection.indexes();
    console.log('\nCurrent indexes on Consultation collection:');
    indexes.forEach(idx => {
      console.log(`- ${idx.name}: ${JSON.stringify(idx.key)}`);
    });
    
    console.log('\nConsultation index optimization completed.');
  } catch (error) {
    console.error('Error during index optimization:', error);
    throw error;
  }
}

module.exports = {
  consultationIndexes,
  applyConsultationIndexes
};