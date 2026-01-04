// Load environment variables
require('dotenv').config();

// Set GOOGLE_APPLICATION_CREDENTIALS if not set
if (!process.env.GOOGLE_APPLICATION_CREDENTIALS) {
  process.env.GOOGLE_APPLICATION_CREDENTIALS = './src/config/petshopapp-b0d2a-firebase-adminsdk-fbsvc-823317f56c.json';
}

const { getFirestore, initializeFirebase } = require('../src/config/firebase');
const admin = require('firebase-admin');

// Initialize Firebase before using it
initializeFirebase();

/**
 * Seed demo pets data to Firebase Firestore
 * Run with: node scripts/seedPets.js
 */

const demoPets = [
  {
    name: 'Max',
    breed: 'Golden Retriever',
    age: '2 years',
    gender: 'Male',
    weight: '25 kg',
    color: 'Golden',
    location: 'Istanbul, Turkey',
    distance: '2.5 km',
    price: 5000,
    imageUrl: 'https://images.unsplash.com/photo-1551717743-49959800b1f6?w=800',
    description: 'Friendly and energetic Golden Retriever looking for a loving home. Max loves playing fetch and going for long walks.',
    category: 'dogs',
    owner: {
      name: 'Ahmet Yılmaz',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    },
    healthStatus: {
      vaccines: true,
      neutered: true,
      healthRecord: true,
    },
  },
  {
    name: 'Luna',
    breed: 'Persian Cat',
    age: '1 year',
    gender: 'Female',
    weight: '4 kg',
    color: 'White',
    location: 'Ankara, Turkey',
    distance: '5.0 km',
    price: 3500,
    imageUrl: 'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=800',
    description: 'Beautiful Persian cat with a calm and gentle personality. Luna is perfect for families with children.',
    category: 'cats',
    owner: {
      name: 'Ayşe Demir',
      imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
    },
    healthStatus: {
      vaccines: true,
      neutered: true,
      healthRecord: true,
    },
  },
  {
    name: 'Charlie',
    breed: 'Labrador',
    age: '3 years',
    gender: 'Male',
    weight: '30 kg',
    color: 'Black',
    location: 'Izmir, Turkey',
    distance: '1.8 km',
    price: 4500,
    imageUrl: 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=800',
    description: 'Loyal and intelligent Labrador. Charlie is well-trained and great with kids and other pets.',
    category: 'dogs',
    owner: {
      name: 'Mehmet Kaya',
      imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
    },
    healthStatus: {
      vaccines: true,
      neutered: true,
      healthRecord: true,
    },
  },
  {
    name: 'Mia',
    breed: 'Siamese Cat',
    age: '6 months',
    gender: 'Female',
    weight: '2.5 kg',
    color: 'Cream',
    location: 'Bursa, Turkey',
    distance: '3.2 km',
    price: 2800,
    imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=800',
    description: 'Playful Siamese kitten. Mia is very social and loves attention. Perfect for first-time cat owners.',
    category: 'cats',
    owner: {
      name: 'Zeynep Özkan',
      imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200',
    },
    healthStatus: {
      vaccines: true,
      neutered: false,
      healthRecord: true,
    },
  },
  {
    name: 'Buddy',
    breed: 'German Shepherd',
    age: '4 years',
    gender: 'Male',
    weight: '35 kg',
    color: 'Brown and Black',
    location: 'Antalya, Turkey',
    distance: '4.5 km',
    price: 6000,
    imageUrl: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=800',
    description: 'Protective and loyal German Shepherd. Buddy is trained and perfect for experienced dog owners.',
    category: 'dogs',
    owner: {
      name: 'Can Arslan',
      imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200',
    },
    healthStatus: {
      vaccines: true,
      neutered: true,
      healthRecord: true,
    },
  },
  {
    name: 'Coco',
    breed: 'Parrot',
    age: '2 years',
    gender: 'Male',
    weight: '0.5 kg',
    color: 'Green and Yellow',
    location: 'Istanbul, Turkey',
    distance: '1.2 km',
    price: 1500,
    imageUrl: 'https://images.unsplash.com/photo-1526318896980-cf78c088247c?w=800',
    description: 'Friendly and talkative parrot. Coco can learn words and loves interacting with people.',
    category: 'birds',
    owner: {
      name: 'Elif Şahin',
      imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
    },
    healthStatus: {
      vaccines: false,
      neutered: false,
      healthRecord: true,
    },
  },
  {
    name: 'Snowball',
    breed: 'Rabbit',
    age: '1 year',
    gender: 'Female',
    weight: '2 kg',
    color: 'White',
    location: 'Ankara, Turkey',
    distance: '6.0 km',
    price: 800,
    imageUrl: 'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?w=800',
    description: 'Cute and fluffy rabbit. Snowball is gentle and perfect for families with children.',
    category: 'rabbits',
    owner: {
      name: 'Burak Çelik',
      imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200',
    },
    healthStatus: {
      vaccines: false,
      neutered: true,
      healthRecord: true,
    },
  },
  {
    name: 'Nemo',
    breed: 'Goldfish',
    age: '6 months',
    gender: 'Male',
    weight: '0.1 kg',
    color: 'Orange',
    location: 'Izmir, Turkey',
    distance: '2.0 km',
    price: 200,
    imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800',
    description: 'Beautiful goldfish perfect for aquariums. Nemo is healthy and active.',
    category: 'fish',
    owner: {
      name: 'Deniz Yıldız',
      imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
    },
    healthStatus: {
      vaccines: false,
      neutered: false,
      healthRecord: false,
    },
  },
  {
    name: 'Rocky',
    breed: 'Bulldog',
    age: '5 years',
    gender: 'Male',
    weight: '22 kg',
    color: 'Brindle',
    location: 'Bursa, Turkey',
    distance: '3.8 km',
    price: 5500,
    imageUrl: 'https://images.unsplash.com/photo-1551717743-49959800b1f6?w=800',
    description: 'Calm and friendly Bulldog. Rocky is great with families and loves lounging around.',
    category: 'dogs',
    owner: {
      name: 'Fatma Aydın',
      imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
    },
    healthStatus: {
      vaccines: true,
      neutered: true,
      healthRecord: true,
    },
  },
  {
    name: 'Whiskers',
    breed: 'British Shorthair',
    age: '2 years',
    gender: 'Male',
    weight: '5 kg',
    color: 'Grey',
    location: 'Antalya, Turkey',
    distance: '4.2 km',
    price: 3200,
    imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=800',
    description: 'Independent and calm British Shorthair. Whiskers is perfect for apartment living.',
    category: 'cats',
    owner: {
      name: 'Serkan Doğan',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    },
    healthStatus: {
      vaccines: true,
      neutered: true,
      healthRecord: true,
    },
  },
];

async function seedPets() {
  try {
    console.log('🌱 Starting to seed pets data...');
    
    const db = getFirestore();
    const batch = db.batch();
    
    // Check if pets already exist and delete empty ones
    const existingPets = await db.collection('pets').get();
    if (!existingPets.empty) {
      console.log(`📋 Found ${existingPets.size} existing pets. Checking for empty records...`);
      
      // Delete pets with empty names (empty records)
      const deleteBatch = db.batch();
      let deletedCount = 0;
      
      existingPets.docs.forEach((doc) => {
        const data = doc.data();
        // Check if pet has empty name or all fields are empty
        if (!data.name || data.name.trim() === '') {
          deleteBatch.delete(doc.ref);
          deletedCount++;
        }
      });
      
      if (deletedCount > 0) {
        await deleteBatch.commit();
        console.log(`🗑️  Deleted ${deletedCount} empty pet records.`);
      } else {
        // Check if we have valid pets
        const validPets = existingPets.docs.filter(doc => {
          const data = doc.data();
          return data.name && data.name.trim() !== '';
        });
        
        if (validPets.length > 0) {
          console.log(`✅ Found ${validPets.length} valid pets. Skipping seed.`);
          console.log('💡 To re-seed, delete existing pets first or use --force flag.');
          process.exit(0);
        }
      }
    }
    
    // Add all pets to batch
    demoPets.forEach((pet) => {
      const docRef = db.collection('pets').doc();
      const petData = {
        ...pet,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      };
      batch.set(docRef, petData);
    });
    
    // Commit batch
    await batch.commit();
    
    console.log(`✅ Successfully seeded ${demoPets.length} pets to Firestore!`);
    console.log('📊 Categories:');
    const categories = {};
    demoPets.forEach((pet) => {
      categories[pet.category] = (categories[pet.category] || 0) + 1;
    });
    Object.entries(categories).forEach(([category, count]) => {
      console.log(`   - ${category}: ${count} pets`);
    });
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error seeding pets:', error);
    process.exit(1);
  }
}

// Run seed function
seedPets();

