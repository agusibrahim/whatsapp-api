FROM node:20

COPY --from=chrishubert/whatsapp-web-api /usr/src/app /usr/src/app
# Set the working directory
WORKDIR /usr/src/app

# Install Google Chrome and dependencies
ENV CHROME_BIN="/usr/bin/google-chrome" \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true" \
    NODE_ENV="production"
RUN set -x \
    && apt-get update \
    && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    fonts-liberation \
    udev \
    --no-install-recommends \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Expose the port the API will run on
EXPOSE 3000

# Start the API
CMD ["npm", "start"]
