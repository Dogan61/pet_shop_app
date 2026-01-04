/**
 * Helper functions for Firestore data serialization
 */

/**
 * Convert Firestore Timestamp to ISO string
 * @param {any} timestamp - Firestore Timestamp or object with _seconds
 * @returns {string|null} ISO string or null
 */
const timestampToISO = (timestamp) => {
  if (!timestamp) return null;
  
  // If it's already a Firestore Timestamp object
  if (timestamp.toDate && typeof timestamp.toDate === 'function') {
    return timestamp.toDate().toISOString();
  }
  
  // If it's an object with _seconds (Firestore Timestamp serialized)
  if (timestamp._seconds) {
    const date = new Date(timestamp._seconds * 1000);
    if (timestamp._nanoseconds) {
      date.setMilliseconds(date.getMilliseconds() + Math.floor(timestamp._nanoseconds / 1000000));
    }
    return date.toISOString();
  }
  
  // If it's already a string, return as is
  if (typeof timestamp === 'string') {
    return timestamp;
  }
  
  return null;
};

/**
 * Recursively convert all Firestore Timestamps in an object to ISO strings
 * @param {any} data - Data object from Firestore
 * @returns {any} Data with timestamps converted to ISO strings
 */
const convertTimestamps = (data) => {
  if (!data) return data;
  
  // If it's an array, process each item
  if (Array.isArray(data)) {
    return data.map(item => convertTimestamps(item));
  }
  
  // If it's an object, process each property
  if (typeof data === 'object' && data !== null) {
    const converted = {};
    for (const [key, value] of Object.entries(data)) {
      // Check if it's a timestamp field
      if (key === 'createdAt' || key === 'updatedAt') {
        converted[key] = timestampToISO(value);
      } else if (typeof value === 'object' && value !== null) {
        // Recursively process nested objects
        converted[key] = convertTimestamps(value);
      } else {
        converted[key] = value;
      }
    }
    return converted;
  }
  
  return data;
};

module.exports = {
  timestampToISO,
  convertTimestamps,
};

