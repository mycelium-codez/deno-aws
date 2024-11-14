import {
  APIGatewayProxyEvent,
  APIGatewayProxyResult,
  Context,
} from "aws-lambda";

// Interface for the expected request body
interface RequestBody {
  // Add your request body properties here
  message?: string;
}

// Interface for structured response
interface ResponseBody {
  success: boolean;
  message: string;
  data?: unknown;
}

// Helper function to create formatted response
const createResponse = (
  statusCode: number,
  body: ResponseBody,
): APIGatewayProxyResult => {
  return {
    statusCode,
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*", // Configure CORS as needed
    },
    body: JSON.stringify(body),
  };
};

// deno-lint-ignore require-await
export const handler = async (
  event: APIGatewayProxyEvent,
  context: Context,
): Promise<APIGatewayProxyResult> => {
  try {
    // Log request details (optional)
    console.log("Event:", JSON.stringify(event));
    console.log("Context:", JSON.stringify(context));

    // Parse request body
    let requestBody: RequestBody = {};
    if (event.body) {
      requestBody = JSON.parse(event.body);
    }

    // Add your business logic here
    const result = {
      success: true,
      message: "Request processed successfully",
      data: {
        receivedMessage: requestBody.message,
        timestamp: new Date().toISOString(),
      },
    };

    // Return successful response
    return createResponse(200, result);
  } catch (error) {
    // Error handling
    console.error("Error:", error);

    return createResponse(500, {
      success: false,
      message: error instanceof Error ? error.message : "Internal server error",
    });
  }
};
