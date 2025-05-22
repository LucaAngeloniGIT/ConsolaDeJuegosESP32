float dinoY, dinoVel;
boolean saltando = false;
boolean agachado = false;
float[] cactusX = new float[2];
float cactusVel;
int score = 0;
boolean gameOver = false;

void setup() {
  size(128, 160);
  dinoY = height - 40;
  dinoVel = 0;
  
  // Configurar cactus
  cactusVel = 1.5;
  cactusX[0] = width + random(50, 100);
  cactusX[1] = width + random(150, 250);
}

void draw() {
  background(255); // Fondo blanco
  
  if (!gameOver) {
    actualizarDino();
    actualizarCactus();
    actualizarScore();
    verificarColision();
  }
  
  dibujarSuelo();
  dibujarCactus();
  dibujarDino();
  dibujarScore();
  
  if (gameOver) {
    dibujarGameOver();
  }
}

void dibujarSuelo() {
  stroke(0); // Línea negra
  line(0, height-20, width, height-20);
}

void dibujarDino() {
  stroke(0); // Contorno negro
  noFill();  // Sin relleno
  
  if (agachado) {
    // Dinosaurio agachado (forma simple)
    beginShape();
    vertex(20, dinoY);
    vertex(40, dinoY);
    vertex(45, dinoY+10);
    vertex(35, dinoY+15);
    vertex(25, dinoY+15);
    vertex(15, dinoY+10);
    endShape(CLOSE);
    
    // Ojo
    ellipse(38, dinoY+5, 3, 3);
  } else {
    // Dinosaurio de pie (forma simple)
    beginShape();
    vertex(20, dinoY);
    vertex(30, dinoY-15);
    vertex(40, dinoY-10);
    vertex(45, dinoY);
    vertex(40, dinoY+15);
    vertex(30, dinoY+20);
    vertex(20, dinoY+15);
    endShape(CLOSE);
    
    // Ojo
    ellipse(38, dinoY-5, 3, 3);
    
    // Patas (alternando para animación)
    if (frameCount % 20 < 10) {
      line(25, dinoY+15, 25, dinoY+25);
      line(35, dinoY+10, 35, dinoY+20);
    } else {
      line(25, dinoY+10, 25, dinoY+20);
      line(35, dinoY+15, 35, dinoY+25);
    }
  }
}

void dibujarCactus() {
  stroke(0); // Contorno negro
  noFill();  // Sin relleno
  
  for (int i = 0; i < cactusX.length; i++) {
    // Cactus simple
    rect(cactusX[i], height-40, 10, 20);
    line(cactusX[i]+5, height-60, cactusX[i]+5, height-40);
    line(cactusX[i]-5, height-50, cactusX[i], height-50);
  }
}

void actualizarDino() {
  if (saltando) {
    dinoY += dinoVel;
    dinoVel += 0.4;
    
    if (dinoY > height - (agachado ? 30 : 40)) {
      dinoY = height - (agachado ? 30 : 40);
      saltando = false;
      dinoVel = 0;
    }
  }
}

void actualizarCactus() {
  for (int i = 0; i < cactusX.length; i++) {
    cactusX[i] -= cactusVel;
    
    if (cactusX[i] < -20) {
      cactusX[i] = width + random(100, 200);
    }
  }
}

void actualizarScore() {
  score++;
}

void verificarColision() {
  for (int i = 0; i < cactusX.length; i++) {
    if (20 < cactusX[i] + 10 && 40 > cactusX[i] && 
        dinoY < height-20 && dinoY+20 > height-40) {
      gameOver = true;
    }
  }
}

void dibujarScore() {
  fill(0);
  textSize(10);
  text("Score: " + (score/10), 10, 20);
}

void dibujarGameOver() {
  fill(0);
  textSize(14);
  text("GAME OVER", width/2 - 35, height/2);
  textSize(10);
  text("Press R", width/2 - 20, height/2 + 20);
}

void keyPressed() {
  if (key == ' ' && !saltando && !gameOver) {
    saltando = true;
    dinoVel = -8;
  }
  
  if (keyCode == DOWN) {
    agachado = true;
  }
  
  if (key == 'r' || key == 'R') {
    reiniciarJuego();
  }
}

void keyReleased() {
  if (keyCode == DOWN) {
    agachado = false;
  }
}

void reiniciarJuego() {
  gameOver = false;
  score = 0;
  dinoY = height - 40;
  dinoVel = 0;
  saltando = false;
  agachado = false;
  
  cactusX[0] = width + random(100, 200);
  cactusX[1] = width + random(200, 300);
}
