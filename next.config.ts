import type { NextConfig } from "next";
import path from "path";

const nextConfig: NextConfig = {
  reactStrictMode: true,
  typescript: {
    ignoreBuildErrors: true,
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  images: {
    unoptimized: true,
  },
  trailingSlash: false,
  webpack: (config) => {
    config.resolve.alias = {
      ...config.resolve.alias,
      "@assets": path.resolve(__dirname, "attached_assets"),
    };
    return config;
  },
};

export default nextConfig;
