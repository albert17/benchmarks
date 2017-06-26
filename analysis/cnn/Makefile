CXX = g++
CXXFLAGS = -O3 -g 
INC= # Add yours
LIB=-lglog -lcaffe -lboost_filesystem # Add yours


single: classification.cpp
	$(CXX) -o classification $(CXXFLAGS) $(INC) $(LIB) classification.cpp

clean:
	rm classification
