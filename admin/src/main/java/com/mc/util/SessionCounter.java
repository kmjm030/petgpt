package com.mc.util;

import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import org.springframework.stereotype.Component;

import java.util.concurrent.atomic.AtomicInteger;

@Component
public class SessionCounter implements HttpSessionListener {

  private static final AtomicInteger activeSessions = new AtomicInteger(0);

  @Override
  public void sessionCreated(HttpSessionEvent se) {
    activeSessions.incrementAndGet();
  }

  @Override
  public void sessionDestroyed(HttpSessionEvent se) {
    activeSessions.decrementAndGet();
  }

  public static int getActiveSessionCount() {
    return activeSessions.get();
  }
}

