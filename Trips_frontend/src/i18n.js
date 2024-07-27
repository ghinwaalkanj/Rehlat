import i18n from "i18next";
import { initReactI18next } from "react-i18next";
import translationAr from './local/ar.json'
import translationEn from './local/en.json'
import LanguageDetector from "i18next-browser-languagedetector"

const resources = {
  en: {
    translation:translationEn,
  },
  ar: {
    translation:translationAr,
  },
};

i18n
  .use(LanguageDetector)
  .use(initReactI18next) 
  .init({
    resources: resources,
    lng: "ar", 
    fallbackLng: "en",
    interpolation: {
      escapeValue: false, 
    },
  });
