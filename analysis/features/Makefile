CXX = g++
CXXFLAGS = -O3 -march=native
INC= # Add
LIB= -lopencv_features2d  -lopencv_imgcodecs -lopencv_imgproc -lopencv_core # Add


features: features.o 
	$(CXX) $(CXXFLAGS) -o features $(INC) $(LIB) features.o

features.o: features.cpp
	$(CXX) -c $(CXXFLAGS) $(INC) $(LIB) features.cpp

clean:
	rm features *.o
