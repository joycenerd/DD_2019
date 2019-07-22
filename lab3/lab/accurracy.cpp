#define NODE_LAYER_0 784
#define NODE_LAYER_1 28 // hidden dimension
#define NODE_LAYER_2 10
#define BUFFER_SIZE 2352

bool MyWindow::accuracy(){

	float w_h1[NODE_LAYER_1][NODE_LAYER_0];
	float w_o[NODE_LAYER_2][NODE_LAYER_1];
	float b_h1[NODE_LAYER_1];
	float b_o[NODE_LAYER_2];

	float v_h1[NODE_LAYER_1];

	int input[NODE_LAYER_0];
	float inputf[NODE_LAYER_0];
	FILE *fileprint;
	char filename[64];
	int i, j;

	float max;
	
	// training data //
	strcpy(filename, "merge.txt");

	fileprint = fopen(filename, "r");
	if (fileprint==NULL){
		puts("ERROR: read model.");
		exit(-1);
	}
	for (i=0;i<NODE_LAYER_1;i++)
		for (j=0;j<NODE_LAYER_0;j++)
			fscanf(fileprint, "%x", (unsigned int*)&w_h1[i][j]);
		
	for (i=0;i<NODE_LAYER_1;i++)
		fscanf(fileprint, "%x", (unsigned int*)&b_h1[i]);
	
	for (i=0;i<NODE_LAYER_2;i++)
		for (j=0;j<NODE_LAYER_1;j++)
			fscanf(fileprint, "%x", (unsigned int*)&w_o[i][j]);
		
	for (i=0;i<NODE_LAYER_2;i++)
		fscanf(fileprint, "%x", (unsigned int*)&b_o[i]);
	
	fclose(fileprint);
	
	// input data 
	unsigned char buffer[BUFFER_SIZE];
	fileprint = fopen(img_name, "r");
	//fileprint = fopen("00001.ppm", "r");

	if (fileprint==NULL){
		puts("err input");
		return 0;
	}
	
	fseek(fileprint, 14, SEEK_SET);//skip title(magic number etc.)//
	fread(buffer,1,BUFFER_SIZE,fileprint);
	
	for (i=0;i<NODE_LAYER_0;i++){
		input[i]=buffer[i*3];
		/*
		printf("%02d ",255-input[i]);
		if (i%28 == 27)
			printf("\n");
		*/
	}
	printf("\n");
	fclose(fileprint);	
	// Pixel format convertion. //
	for (i=0;i<NODE_LAYER_0;i++){
		input[i] = 255 - input[i];
		inputf[i] = ((float)input[i]) * (1.0/255.0);
	}

	// Calculate hidden layer 1. //
	for (i=0;i<NODE_LAYER_1;i++){
		v_h1[i] = 0.0;
		
		for (j=0;j<NODE_LAYER_0;j++){
			v_h1[i] += inputf[j]*w_h1[i][j];
		}

	}
	for (i=0;i<NODE_LAYER_1;i++){
		v_h1[i] += b_h1[i];
		if(v_h1[i]<0.0)	v_h1[i] = 0.0;
	}
	
	// Calculate output layer. //
	for (i=0;i<NODE_LAYER_2;i++){
		results[i] = 0.0;
		for (j=0;j<NODE_LAYER_1;j++)
			results[i] += v_h1[j]*w_o[i][j];
	}
	for (i=0;i<NODE_LAYER_2;i++)
		results[i] += b_o[i];
	
	for (i=0;i<10;i++)
		printf("results[%d]: %f\n", i , results[i]);
	printf("\n");
	
	// Find max value. //
	max = results[0];
	max_idx = 0;
	for (i=1;i<NODE_LAYER_2;i++)
		if(max<results[i]){
			max_idx = i;
			max = results[i];
		}	
	printf("Final ans:%d\n",max_idx);//max_idx ?箸?��????	printf("--sw_end--\n");	
	return true;
}







/* calculate accuracy */
bool MyWindow::accuracy(){
	int idxi, idxj, idxk;

	// load weights and biases from pre-trained model
    float w_hidden1[HIDDEN1_DIM][INPUT_DIM];
    float b_hidden1[HIDDEN1_DIM];
    float w_output[10][HIDDEN1_DIM];
    float b_output[10];
	int utemp;
    FILE *fp = fopen(DNN_PARAM_PATH, "r");
    assert(fp != NULL);

    for(idxi = 0; idxi < HIDDEN1_DIM; idxi++){
        for(idxj = 0; idxj < INPUT_DIM; idxj++){
            fscanf(fp, "%x", &utemp);
            w_hidden1[idxi][idxj] = *((unsigned int *)&utemp);
        }
    }

    for(idxi = 0; idxi < HIDDEN1_DIM; idxi++){
        fscanf(fp, "%x", &utemp);
        b_hidden1[idxi] = *((unsigned int *)&utemp);
    }

    for(idxi = 0; idxi < OUTPUT_DIM; idxi++){
        for(idxj = 0; idxj < HIDDEN1_DIM; idxj++){
            fscanf(fp, "%x", &utemp);
            w_output[idxi][idxj] = *((unsigned int *)&utemp);
        }
    }

    for(idxi = 0; idxi < OUTPUT_DIM; idxi++){
        fscanf(fp, "%x", &utemp);
        b_output[idxi] = *((unsigned int *)&utemp);
    }

    fclose(fp);

	// input data 
	unsigned char buffer[BUFFER_SIZE];
	int input[INPUT_DIM];
	fp = fopen(img_name, "r");
	//fileprint = fopen("00001.ppm", "r");

	if (fp==NULL){
		puts("err input");
		return 0;
	}
	
	fseek(fp, 14, SEEK_SET);//skip title(magic number etc.)//
	fread(fp,1,BUFFER_SIZE,fp);

	for (i=0;i<INPUT_DIM;i++) input[i]=buffer[i*3];

	fclose(fp);

	// DNN inference
    float v_hidden1[HIDDEN1_DIM];
    float v_output[OUTPUT_DIM];
    float v_input[INPUT_DIM];
    float maxval, ncorrect = 0;
    int  temp, maxidx;

	// Pixel format convertion. //
	for (i=0;i<INPUT_DIM;i++){
		v_input[i] = (float)(255 - input[i]) * (1.0 / 255.0);
	}

	// Calculate hidden layer 1. //
	for (i=0;i<HIDDEN1_DIM;i++){
		v_hidden1[idxi] = b_hidden1[idxi];
		for (j=0;j<INPUT_DIM;j++){
			v_hidden1[i] += v_input[j] * w_hidden1[i][j];
		}
		v_hidden1[i] = v_hidden1[i] > 0 ? v_hidden1[j] : 0;
	}

	// Calculate output layer. //
	for (i=0;i<OUTPUT_DIM;i++){
		v_output[i] = b_output[i];
		for (j=0;j<HIDDEN1_DIM;j++){
			v_output[i] += v_hidden1[j] * w_output[i][j];
		}
	}

	for (i=0;i<10;i++) printf("result[%d]: %f\n", i , v_output[i]);
	printf("\n");

	// Find max value. //
	maxval = 0;
	maxidx = 0;
	for (i=1;i<OUTPUT_DIM;i++)
		if(maxval<v_output[i]){
			maxidx = i;
			max = v_output[i];
		}	
	printf("Final ans:%d\n",maxidx);//max_idx ?箸?��????	printf("--sw_end--\n");	
	return true;
}