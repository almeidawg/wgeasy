import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';

const SplashScreen = ({ onComplete }) => {
  const [phase, setPhase] = useState(0);

  useEffect(() => {
    // Phase 0: Initial black
    const timer0 = setTimeout(() => setPhase(1), 300);
    // Phase 1: Wine swirl appears and rotates
    const timer1 = setTimeout(() => setPhase(2), 1800);
    // Phase 2: Logo fades in
    const timer2 = setTimeout(() => setPhase(3), 3000);
    // Phase 3: Everything fades out
    const timer3 = setTimeout(() => onComplete(), 4200);

    return () => {
      clearTimeout(timer0);
      clearTimeout(timer1);
      clearTimeout(timer2);
      clearTimeout(timer3);
    };
  }, [onComplete]);

  return (
    <AnimatePresence>
      <motion.div
        initial={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        transition={{ duration: 1 }}
        className="fixed inset-0 z-[100] bg-[#0a0a0a] flex items-center justify-center overflow-hidden"
      >
        {/* Cinematic black bars */}
        <motion.div
          initial={{ height: '15%' }}
          animate={{ height: phase >= 3 ? '50%' : '15%' }}
          transition={{ duration: 1.2 }}
          className="absolute top-0 left-0 right-0 bg-black z-20"
        />
        <motion.div
          initial={{ height: '15%' }}
          animate={{ height: phase >= 3 ? '50%' : '15%' }}
          transition={{ duration: 1.2 }}
          className="absolute bottom-0 left-0 right-0 bg-black z-20"
        />

        {/* Wine swirl - Van Gogh brushstroke */}
        <motion.div
          initial={{ opacity: 0, scale: 0.3, rotate: -180 }}
          animate={{
            opacity: phase >= 1 ? 1 : 0,
            scale: phase >= 1 ? (phase >= 2 ? 1.5 : 1) : 0.3,
            rotate: phase >= 1 ? (phase >= 2 ? 360 : 0) : -180,
          }}
          transition={{
            duration: 1.5,
            ease: "easeOut",
            rotate: { duration: 2, ease: "easeInOut" }
          }}
          className="absolute z-10"
        >
          <img
            src="/wine-swirl.png"
            alt=""
            className="w-64 md:w-80 lg:w-96 h-auto"
            style={{
              filter: phase >= 2 ? 'brightness(1.2) saturate(1.3)' : 'brightness(0.8)',
              transition: 'filter 0.8s ease'
            }}
          />
        </motion.div>

        {/* Glow effect behind swirl */}
        <motion.div
          initial={{ opacity: 0, scale: 0 }}
          animate={{
            opacity: phase >= 1 ? 0.4 : 0,
            scale: phase >= 1 ? 1.5 : 0,
          }}
          transition={{ duration: 1.2 }}
          className="absolute w-80 h-80 rounded-full bg-[#722F37] blur-[100px] z-0"
        />

        {/* Logo and text */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{
            opacity: phase >= 2 ? 1 : 0,
            y: phase >= 2 ? 0 : 30,
          }}
          transition={{ duration: 0.8, delay: 0.3 }}
          className="absolute z-30 text-center"
        >
          <motion.h1
            className="text-5xl md:text-7xl lg:text-8xl font-signature text-white tracking-wider"
            style={{ textShadow: '0 0 40px rgba(114, 47, 55, 0.5)' }}
          >
            Wno Mas
          </motion.h1>
          <motion.p
            initial={{ opacity: 0 }}
            animate={{ opacity: phase >= 2 ? 0.7 : 0 }}
            transition={{ duration: 0.6, delay: 0.6 }}
            className="text-sm md:text-base text-white/60 tracking-[0.3em] uppercase mt-4"
          >
            Vinho & Companhia
          </motion.p>
        </motion.div>

        {/* Tagline */}
        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: phase >= 2 ? 1 : 0 }}
          transition={{ duration: 0.6, delay: 0.8 }}
          className="absolute bottom-[20%] text-white/40 text-sm md:text-base font-signature italic z-30"
        >
          "Quando o vinho é bom, a vontade é continuar."
        </motion.p>

        {/* Loading line */}
        <div className="absolute bottom-[12%] left-1/2 transform -translate-x-1/2 w-32 md:w-48 h-[1px] bg-white/10 z-30 overflow-hidden">
          <motion.div
            initial={{ x: '-100%' }}
            animate={{ x: '100%' }}
            transition={{
              duration: 1.5,
              repeat: phase < 3 ? Infinity : 0,
              ease: "linear"
            }}
            className="h-full w-1/2 bg-gradient-to-r from-transparent via-[#722F37] to-transparent"
          />
        </div>
      </motion.div>
    </AnimatePresence>
  );
};

export default SplashScreen;
