const { jestConfig } = require('@salesforce/sfdx-lwc-jest/config');

module.exports = {
    ...jestConfig,
    modulePathIgnorePatterns: ['<rootDir>/.localdevserver'],
    moduleNameMapper: {
        '^lightning/mobileCapabilities$': '<rootDir>/force-app/test/jest-mocks/lightning/mobileCapabilities',
        '^lightning/platformResourceLoader$': '<rootDir>/force-app/test/jest-mocks/lightning/platformResourceLoader'
    }
};
